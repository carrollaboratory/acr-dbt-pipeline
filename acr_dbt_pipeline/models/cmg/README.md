# CMG Parquet source pipeline

This dbt project reads local TDR snapshot exports as Parquet files with
DuckDB. It does not connect to BigQuery or Google Cloud Storage.

## Source configuration

Parquet sources are configured in `dbt_project.yml`. `vars.tdr_parquet_root`
holds the shared location of the exports, and `vars.tdr_parquet_sources` holds
one entry per snapshot:

```yaml
tdr_parquet_root: "/home/rstudio/pipelines/data/cmg_harmonization_2026"

tdr_parquet_sources:
  cmg_yale_gru:
    path: "yale/_GRU__{table}-*.parquet"
    snapshot_id: "d3caa579-e6f0-458e-859b-008d89af0b48"
```

All 19 exported CMG snapshots (9 Yale, 10 UWash) are configured. The logical
name of each is derived from its `title` in `scripts/anvil_dataset_export.csv`,
lowercased (for example `ANVIL_CMG_UWASH_DS_BAV_IRB_PUB_RD` becomes
`cmg_uwash_ds_bav_irb_pub_rd`).

To use another local directory, override the root:

```bash
dbt run \
  --profiles-dir . \
  --vars '{"tdr_parquet_root": "/path/to/cmg_harmonization_2026"}'
```

Each source path is relative to `tdr_parquet_root` and must include `{table}`
so one relation resolves to exactly one table's shards. The expected layout is:

```text
/home/rstudio/pipelines/data/cmg_harmonization_2026/yale/_GRU__anvil_dataset-000000000000.parquet
```

## Runtime

The DuckDB profile is in `profiles.yml`. Parquet reading is built into DuckDB,
so no DuckDB extensions need to be installed. `DBT_DUCKDB_PATH` remains an
optional output-database setting; it is not a source-data credential.

Run from the dbt project directory:

```bash
dbt deps
dbt debug --profiles-dir .
dbt parse --profiles-dir .
dbt compile --profiles-dir . --select cmg_yale_src_anvil_dataset
dbt run --profiles-dir . --select cmg_yale_src_anvil_dataset
dbt test --profiles-dir . --select cmg_yale_src_anvil_dataset
```

The first source model is
`cmg_yale_src_anvil_dataset.sql`. It reads the configured
`cmg_yale_gru` Parquet path with DuckDB `read_parquet`, normalizes column names
and values, and records the configured snapshot ID as provenance.

## Column normalization

`normalize_parquet_columns` introspects the Parquet file and emits a compact
select list instead of one `CASE` block per column:

```sql
select
  acr_clean_text(COLUMNS(['consent_group', 'title', ...])),
  COLUMNS(['some_numeric_column']),
  ...
```

Only `VARCHAR` columns are passed through `acr_clean_text`, which trims the
value and returns `NULL` when the result is empty or matches
`vars.source_null_sentinels`.

Every non-text column is selected as-is, so this layer never introduces a
`varchar` round-trip that could reformat a number.

That is a *no-added-loss* guarantee, not an exactness guarantee. What survives
depends on how the column was typed when the Parquet file was written:

| Parquet type | What is preserved |
| --- | --- |
| `DECIMAL(p,s)` | the exact decimal value |
| `VARCHAR` | the exact original text, including trailing zeros |
| `DOUBLE` / `FLOAT` | the stored binary value, which is only an approximation of a decimal |

`DOUBLE` is binary floating point, so a value such as `0.1` is already
approximate in the file itself, and formatting such as `1.50` is already gone.
No SQL in this project can recover that — if a column must be exact, it has to
be exported as `DECIMAL(p,s)` (or kept as text) at the BigQuery `EXPORT DATA`
step, not fixed downstream.

`acr_clean_text` is installed into the DuckDB database by the `on-run-start`
hook, so the cleaning rule is defined once rather than repeated per column.

To add another snapshot, add another entry under `tdr_parquet_sources` and
create a model that calls `tdr_snapshot_path('<name>', '<table>')`.
