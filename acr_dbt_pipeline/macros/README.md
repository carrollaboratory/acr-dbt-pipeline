# Macros

Macros are separated by ownership so study-specific harmonization changes do
not accidentally alter pipeline-wide behavior.

## `pipeline/`

Shared architecture macros. Harmonizers may call and configure these macros but
should not modify, copy, or override them for one dataset.

See [pipeline/README.md](pipeline/README.md) for responsibilities, ownership,
and change requirements.

The core CMG flow is:

1. `pipeline/raw_source_ingestion/` resolves local Parquet inputs.
2. `pipeline/source_selection/` selects snapshots and derives tags/model names.
3. `pipeline/main_stage/` unions source models with normalized column names.
4. `pipeline/int_stage/` applies shared value cleaning once after the union.

## `data_cleaning/`

Harmonizer-facing reusable cleaning expressions that are not required by the
pipeline architecture. Add narrowly scoped, reusable data-cleaning macros here.

## `ad_hoc/`

Profiling query generators (`profile_*`) and `store_profile`. See
[ad_hoc/docs/profiling_quickstart.md](ad_hoc/docs/profiling_quickstart.md).

## `uri_curie/`

`normalize_curie` and its `regex_match` helper.

## Macros copied from dbt_pipeline_utils

ACR does not import the `dbt_pipeline_utils` package. The macros it uses
(`pipeline/identifiers/`, `pipeline/warehouse_naming/`, `ad_hoc/`,
`uri_curie/`) are local copies. Each file starts with an
`Originally sourced from dbt_pipeline_utils (...)` note naming its source
file. Call them without a namespace. Keep them in sync with
`dbt-pipeline-utils` by hand.

## Adding a macro

- Put study-specific SQL in a model first.
- Extract a macro only when the behavior is genuinely reusable.
- Use one public macro per file.
- Put it under `pipeline/` only when the pipeline itself depends on it.
- If other pipelines could use it, also add it to `dbt-pipeline-utils`, and
  mark the ACR copy as originally sourced from there.
- Do not give a new macro the same name as an existing macro; dbt macro names
  are global even when files live in different directories.
