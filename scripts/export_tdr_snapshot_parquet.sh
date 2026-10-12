#!/usr/bin/env bash
#
# Export the TDR snapshots listed in an anvil_dataset TSV with one BigQuery
# script submission. Tables are discovered from INFORMATION_SCHEMA.
#
# Required TSV columns:
#   bq_source_project
#   bq_dataset_name
#   parquet_destination_bucket
#
# Usage:
#   scripts/export_tdr_snapshot_parquet.sh scripts/anvil_dataset.tsv
#
# Environment:
#   BQ_LOCATION  BigQuery job location. Defaults to US.
#   JOB_PROJECT  Project that owns and is billed for the job.
#                Defaults to ${GOOGLE_PROJECT}.
#
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <anvil-dataset.tsv>" >&2
  exit 1
fi

metadata_file="$1"
if [[ ! -r "$metadata_file" ]]; then
  echo "Cannot read anvil dataset TSV: $metadata_file" >&2
  exit 1
fi

for tool in bq python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Required tool not found: $tool" >&2
    exit 1
  fi
done

job_project="${JOB_PROJECT:-${GOOGLE_PROJECT:-}}"
if [[ -z "$job_project" ]]; then
  echo "Set JOB_PROJECT (or GOOGLE_PROJECT) to the Terra workspace project." >&2
  exit 1
fi

destination_root="${PARQUET_DESTINATION_ROOT:-}"
if [[ -n "$destination_root" ]]; then
  echo "PARQUET_DESTINATION_ROOT is ignored: destinations come from the" >&2
  echo "parquet_destination_bucket column in ${metadata_file}." >&2
  exit 1
fi

bq_location="${BQ_LOCATION:-US}"
resolved_catalog="$(mktemp)"
trap 'rm -f "$resolved_catalog"' EXIT

python3 - "$metadata_file" >"$resolved_catalog" <<'PY'
import csv
import re
import sys

metadata_file = sys.argv[1]
required = {"bq_source_project", "bq_dataset_name", "parquet_destination_bucket"}
project_pattern = re.compile(r"^[a-z][a-z0-9-]{4,28}[a-z0-9]$")
dataset_pattern = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def validated_destination(template: str, row_number: int) -> str:
    if not template.startswith("gs://"):
        fail(f"row {row_number}: destination must start with gs://: {template!r}")
    if not template.endswith(".parquet"):
        fail(f"row {row_number}: destination must end with .parquet: {template!r}")
    # EXPORT DATA requires exactly one shard placeholder in the URI.
    if template.count("*") != 1:
        fail(
            f"row {row_number}: destination needs exactly one '*': {template!r}"
        )
    if any(character.isspace() for character in template) or "'" in template:
        fail(
            f"row {row_number}: destination cannot contain whitespace or a "
            f"quote: {template!r}"
        )
    return template


with open(metadata_file, encoding="utf-8-sig", newline="") as handle:
    reader = csv.DictReader(handle, delimiter="\t")
    if reader.fieldnames is None:
        fail("the TSV has no header")

    missing = sorted(required - set(reader.fieldnames))
    if missing:
        fail(f"missing required column(s): {', '.join(missing)}")

    seen_sources = set()
    seen_destinations = set()
    exported_rows = 0

    for row_number, row in enumerate(reader, start=2):
        if not any((value or "").strip() for value in row.values()):
            continue

        project = (row["bq_source_project"] or "").strip()
        dataset = (row["bq_dataset_name"] or "").strip()
        destination = (row["parquet_destination_bucket"] or "").strip()

        if not project_pattern.fullmatch(project):
            fail(f"row {row_number}: invalid bq_source_project: {project!r}")
        if not dataset_pattern.fullmatch(dataset):
            fail(f"row {row_number}: invalid bq_dataset_name: {dataset!r}")
        if not destination:
            fail(f"row {row_number}: parquet_destination_bucket is empty")

        destination = validated_destination(destination, row_number)
        source_key = (project, dataset)

        if source_key in seen_sources:
            fail(f"row {row_number}: duplicate BigQuery source: {project}.{dataset}")
        if destination in seen_destinations:
            fail(f"row {row_number}: duplicate destination: {destination}")

        seen_sources.add(source_key)
        seen_destinations.add(destination)
        print("\t".join((project, dataset, destination)))
        exported_rows += 1

    if exported_rows == 0:
        fail("the TSV contains no exportable rows")
PY

catalog_sql=""
catalog_size=0
while IFS=$'\t' read -r source_project source_dataset destination_template; do
  if [[ -n "$catalog_sql" ]]; then
    catalog_sql+=","
  fi
  catalog_sql+=$'\n'
  catalog_sql+="  STRUCT("
  catalog_sql+="'${source_project}' AS source_project, "
  catalog_sql+="'${source_dataset}' AS source_dataset, "
  catalog_sql+="'${destination_template}' AS destination_template)"
  catalog_size=$((catalog_size + 1))
done <"$resolved_catalog"

echo "Metadata:    ${metadata_file}"
echo "Snapshots:   ${catalog_size}"
echo "Job project: ${job_project} (${bq_location})"
echo

bq \
  --project_id="$job_project" \
  --location="$bq_location" \
  query \
  --use_legacy_sql=false \
  --quiet \
  <<SQL
DECLARE snapshot_catalog ARRAY<STRUCT<
  source_project STRING,
  source_dataset STRING,
  destination_template STRING
>> DEFAULT [
${catalog_sql}
];
DECLARE found_tables ARRAY<STRING>;

FOR snapshot IN (
  SELECT source_project, source_dataset, destination_template
  FROM UNNEST(snapshot_catalog)
)
DO
  EXECUTE IMMEDIATE FORMAT(
    '''
    SELECT ARRAY_AGG(table_name ORDER BY table_name)
    FROM \`%s.%s.INFORMATION_SCHEMA.TABLES\`
    WHERE table_name NOT IN ('datarepo_row_ids', 'workspace_attributes')
    ''',
    snapshot.source_project,
    snapshot.source_dataset
  )
  INTO found_tables;

  SET found_tables = IFNULL(found_tables, []);

  IF ARRAY_LENGTH(found_tables) = 0 THEN
    RAISE USING MESSAGE = FORMAT(
      'No exportable tables found in %s.%s',
      snapshot.source_project,
      snapshot.source_dataset
    );
  END IF;

  SELECT FORMAT(
    'Exporting %d table(s) from %s.%s to %s',
    ARRAY_LENGTH(found_tables),
    snapshot.source_project,
    snapshot.source_dataset,
    snapshot.destination_template
  ) AS export_status;

  FOR table_record IN (
    SELECT table_name
    FROM UNNEST(found_tables) AS table_name
  )
  DO
    EXECUTE IMMEDIATE FORMAT(
      '''
      EXPORT DATA OPTIONS (
        uri = '%s',
        format = 'PARQUET',
        compression = 'SNAPPY',
        overwrite = true
      ) AS
      SELECT *
      FROM \`%s.%s.%s\`
      ''',
      REPLACE(
        snapshot.destination_template,
        '*',
        CONCAT(table_record.table_name, '-*')
      ),
      snapshot.source_project,
      snapshot.source_dataset,
      table_record.table_name
    );
  END FOR;
END FOR;
SQL

echo
echo "Exported ${catalog_size} snapshot(s)."
echo "List exported files with:"
echo "  gcloud storage ls --recursive '<parquet_destination_bucket prefix>/'"
