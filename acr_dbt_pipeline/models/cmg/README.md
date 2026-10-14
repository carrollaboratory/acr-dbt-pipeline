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

To add another snapshot, add another entry under `tdr_parquet_sources` and
create a model that calls `tdr_snapshot_path('<name>', '<table>')`.
