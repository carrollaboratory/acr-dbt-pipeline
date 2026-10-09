# CMG TDR source pipeline

This dbt project reads TDR snapshot tables directly from BigQuery and
materializes normalized models in a local DuckDB database. It does not require
a paid dbt account and does not export intermediate CSV files.

## Runtime choice

The Terra startup script uses the established Python adapter stack:

- `dbt-core==1.11.11`
- `dbt-duckdb==1.11.0`

dbt v2 was not selected for this first slice because loading the community
BigQuery extension requires a separately installed DuckDB driver through
`dbc`. That adds another compatibility boundary inside Terra. The pinned
Python adapter supports the required DuckDB extension and attachment settings
without mixing dbt runtimes.

`dbt-bigquery` is not required for this design. dbt targets DuckDB, and DuckDB's
community BigQuery extension reads the remote source tables. Add the BigQuery
adapter only if a separate dbt target will materialize models in BigQuery.

## Terra environment

Run `scripts/terra_startup_rstudio_dbt_pipeline_v1.sh` once when the
workspace starts, then activate the environment:

```bash
source /home/rstudio/venv-dbt/bin/activate
```

The script writes the shared snapshot configuration to
`/home/rstudio/.acr_dbt_pipeline.env` and adds an idempotent source line to
`/home/rstudio/.bashrc`. New RStudio terminals load it automatically. If the
script is run manually from an already-open terminal, load it there with:

```bash
source /home/rstudio/.acr_dbt_pipeline.env
```

Terra Application Default Credentials must be able to read the snapshot
tables and metadata and create BigQuery Storage Read sessions. The source
project should grant the workspace identity equivalent permissions for:

- `bigquery.tables.get`
- `bigquery.tables.getData`
- `bigquery.tables.list`
- `bigquery.readsessions.create`
- `bigquery.readsessions.getData`
- `bigquery.readsessions.update`

## Shared configuration

Snapshot metadata is supplied through environment variables, but nobody sets
them by hand. The authoritative `.env` lives in the Terra workspace bucket at
`${WORKSPACE_BUCKET}/config/acr_dbt_pipeline.env`. The startup script copies it
to `/home/rstudio/.acr_dbt_pipeline.env`, sources it, and appends a line to
`/home/rstudio/.bashrc` so every later interactive shell picks it up too.

Use the version-controlled [`.env.example`](../../../.env.example) as the
template, then publish a change for the whole workspace with:

```bash
cp .env.example .env     # then edit .env
gcloud storage cp .env "${WORKSPACE_BUCKET}/config/acr_dbt_pipeline.env"
```

Collaborators pick the change up by restarting their runtime, or immediately by
re-running the startup script. `.env` is gitignored; only the template is
committed. Nothing in it is secret, so never add credentials - BigQuery access
uses Terra Application Default Credentials.

Each snapshot contributes three variables, and the naming convention is
load-bearing:

```bash
TDR_CMG_YALE_BQ_PROJECT=datarepo-00000000
TDR_CMG_YALE_BQ_DATASET=datarepo_ANVIL_CMG_Yale_GRU
TDR_CMG_YALE_SNAPSHOT_ID=00000000-0000-0000-0000-000000000000
```

`DBT_DUCKDB_PATH` in the same file selects the local DuckDB output file.

The nine configured logical sources are:

```text
cmg_yale_ds_bpeakd
cmg_yale_ds_mc
cmg_yale_ds_rared
cmg_yale_ds_rd
cmg_yale_ds_thal_irb
cmg_yale_gru
cmg_yale_hmb
cmg_yale_hmb_gso
cmg_yale_hmb_irb
```

The mapping between each logical source and its environment variables is
checked into `dbt_project.yml` under `vars.tdr_snapshots`. `profiles.yml`
attaches each source as a separate read-only BigQuery catalog, which permits
the snapshots to live in different GCP projects. Never reuse an alias for a
different GCP project. The startup script attaches every `TDR_*_BQ_PROJECT` it
finds and fails if any of them cannot be read.

A TDR catalog record or URL such as
`https://data.terra.bio/snapshots/<snapshot-uuid>` supplies the
`*_SNAPSHOT_ID`. That UUID is a stable provenance identifier, but it is not a
BigQuery project or dataset name. Retrieve those two values from the
authenticated TDR metadata endpoint inside Terra, which requires a bearer token:

```bash
curl --fail --silent --show-error \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  "https://data.terra.bio/api/repository/v1/snapshots/${TDR_CMG_YALE_SNAPSHOT_ID}?include=ACCESS_INFORMATION" \
  | jq '.accessInformation.bigQuery | {projectId, datasetName}'
```

## Run the first source model

From `acr_dbt_pipeline/` (the dbt project root):

```bash
cd acr_dbt_pipeline
dbt deps
dbt debug --profiles-dir .
dbt compile --profiles-dir . --select cmg_yale_src_anvil_dataset
dbt run --profiles-dir . --select cmg_yale_src_anvil_dataset
dbt test --profiles-dir . --select cmg_yale_src_anvil_dataset
```

The model reads:

```text
cmg_yale_bq.<TDR_CMG_YALE_BQ_DATASET>.anvil_dataset
```

and writes a table to the local DuckDB file. The source normalization macro:

- lowercases output column names;
- casts all values to `VARCHAR`;
- trims strings;
- converts blanks and case-insensitive `NA`, `N/A`, `null`, and `None` values
  to SQL `NULL`;
- fails if lowercasing or a rename map creates duplicate output names.

The model also records both the logical `source_snapshot` name and physical
`source_snapshot_id` UUID on every row.

## Future multi-snapshot harmonization

Create one declared dbt source and one normalized `src` model per physical TDR
snapshot. Pass semantic equivalents to `normalize_source_columns` with a
lowercase rename map, for example:

```sql
{{ normalize_source_columns(
    source('another_snapshot', 'subject'),
    rename_map={'person_id': 'subject_id'}
) }}
```

The next layer should union the normalized models with `ref()` and
`dbt_utils.union_relations`, retaining `source_snapshot`. Use
`dbt_utils.star` for straightforward projections, but keep semantic renames
explicit: `star` does not know that `person_id` and `Subject_id` mean the same
thing.
