# CMG TDR source pipeline

This dbt project reads TDR snapshot tables directly from BigQuery and
materializes normalized models in a local DuckDB database. It does not require
a paid dbt account and does not export intermediate CSV files.

## Runtime choice

The workspace provides Python 3.12. The v1 Terra startup script installs the
latest mutually compatible releases of:

- `dbt-core`
- `dbt-duckdb`
- `dbt-bigquery`
- `dbt-postgres`

It installs directly into the workspace Python environment; it does not create
a virtual environment or install system packages. R 4.5.1 is independent of
the dbt Python runtime. The R version does not determine dbt or adapter
compatibility.

This project targets DuckDB. `dbt-bigquery` and `dbt-postgres` are installed
for other possible dbt targets, but the current source design reads BigQuery
through DuckDB's community BigQuery extension.

## Terra environment

Run the lightweight setup once when the workspace starts:

```bash
bash scripts/terra_startup_rstudio_dbt_pipeline_v1.sh
```

The startup script only installs dbt packages. It does not create a virtual
environment, download configuration, modify shell startup files, install
system packages, or test TDR access. Configure and load the workspace
variables separately, for example:

```bash
set -a
source /path/to/acr_dbt_pipeline.env
set +a
```

Confirm the installed versions:

```bash
which dbt
dbt --version
```

`which dbt` should point to the workspace's intended Python installation, such
as a pyenv shim or `/usr/local/bin/dbt`. The adapter versions shown by
`dbt --version` should be mutually compatible; pip resolves them together when
the startup script installs them.

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

Snapshot metadata is supplied through environment variables. You may maintain
them directly in the Terra workspace or keep a shared `.env` in the workspace
bucket at `${WORKSPACE_BUCKET}/config/acr_dbt_pipeline.env`. The startup script
does not manage or source that file.

Use the version-controlled [`.env.example`](../../../.env.example) as the
template. If you choose the workspace-bucket approach, publish and load it
explicitly:

```bash
cp .env.example .env     # then edit .env
gcloud storage cp .env "${WORKSPACE_BUCKET}/config/acr_dbt_pipeline.env"
gcloud storage cp \
  "${WORKSPACE_BUCKET}/config/acr_dbt_pipeline.env" \
  /home/rstudio/.acr_dbt_pipeline.env
set -a
source /home/rstudio/.acr_dbt_pipeline.env
set +a
```

`.env` and `.env.*` are gitignored; only the template is committed. Nothing in
it is secret, so never add credentials - BigQuery access uses Terra
Application Default Credentials.

dbt does not automatically read `.env` files. Export the file into the current
shell before `dbt run`. `dbt parse` can run without it for the GRU source
because the profile has a non-secret project-ID fallback, but the run-start
validation intentionally requires all three GRU variables before querying
BigQuery.

Each snapshot contributes three variables, and the naming convention is
load-bearing - the suffix after `TDR_` is the uppercased logical source name:

```bash
TDR_CMG_YALE_GRU_BQ_PROJECT=datarepo-2b98851b
TDR_CMG_YALE_GRU_BQ_DATASET=ANVIL_CMG_Yale_GRU_20221020_ANV5_202507091800
TDR_CMG_YALE_GRU_SNAPSHOT_ID=d3caa579-e6f0-458e-859b-008d89af0b48
```

`DBT_DUCKDB_PATH` in the same file selects the local DuckDB output file.

The nine declared logical sources are:

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
different GCP project.

## Toggling snapshots on and off

Access depends on DUOS approvals, and not every consent group has a published
snapshot, so the project has to build cleanly with only a subset available.
All nine sources are declared at all times, but each is enabled only when its
logical name appears in `TDR_ENABLED_SNAPSHOTS`:

```bash
TDR_ENABLED_SNAPSHOTS=cmg_yale_gru
```

A disabled source and its `src` models are excluded from the manifest
entirely, so dbt never tries to resolve their dataset names. Override the list
for a single invocation without touching the `.env`:

```bash
dbt run --vars '{"enabled_snapshots": "cmg_yale_gru,cmg_yale_hmb"}'
```

Enabling a snapshot takes three steps:

1. add its three `TDR_*` values to the workspace `.env`;
2. add its logical name to `TDR_ENABLED_SNAPSHOTS`;
3. uncomment its `attach` block in `profiles.yml`.

Step 3 is separate because dbt renders `profiles.yml` one value at a time and
cannot loop over a variable. Every `ATTACH` listed there runs when the
connection opens, so leaving a block enabled for a snapshot you cannot read
breaks every model, not just that one. The `on-run-start` hook cross-checks
all three steps and reports exactly which variable or attach block is missing
instead of surfacing a bare DuckDB catalog error.

Adding a brand-new snapshot additionally means adding an entry to
`vars.tdr_snapshots` in `dbt_project.yml`, a source block in `sources.yml`, and
a commented attach block in `profiles.yml`.

## Resolving snapshot metadata

A TDR catalog record or URL such as
`https://data.terra.bio/snapshots/<snapshot-uuid>` supplies the
`*_SNAPSHOT_ID`. That UUID is a stable provenance identifier, but it is **not**
a BigQuery project or dataset name, and the catalog's display name (for example
`ANVIL_CMG_Yale_GRU`) is not necessarily the physical BigQuery dataset either.
Both of those values must come from the authenticated TDR metadata endpoint,
which requires a bearer token and only works inside Terra:

```bash
curl --fail --silent --show-error \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  "https://data.terra.bio/api/repository/v1/snapshots/${SNAPSHOT_ID}?include=ACCESS_INFORMATION" \
  | jq '.accessInformation.bigQuery | {projectId, datasetName}'
```

Doing that nine times by hand is tedious and easy to get wrong, so
[`scripts/fetch_tdr_snapshot_env.sh`](../../../scripts/fetch_tdr_snapshot_env.sh)
automates it. List the logical name and snapshot UUID for each source in
[`scripts/tdr_snapshot_ids.txt`](../../../scripts/tdr_snapshot_ids.txt), then:

```bash
bash scripts/fetch_tdr_snapshot_env.sh scripts/tdr_snapshot_ids.txt
```

It emits the three `TDR_*` lines per snapshot, ready to paste into the
workspace `.env`. Redirect it straight to a file if you prefer:

```bash
bash scripts/fetch_tdr_snapshot_env.sh scripts/tdr_snapshot_ids.txt > .env.generated
```

The script fails loudly per snapshot rather than emitting a wrong value: HTTP
401 means the identity is not registered with Terra, 403 means data access has
not been granted for that snapshot, and an empty `accessInformation` means the
snapshot exists but BigQuery access has not been provisioned for you.

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
cmg_yale_gru_bq.<TDR_CMG_YALE_GRU_BQ_DATASET>.anvil_dataset
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
