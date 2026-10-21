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

Operational and one-off utilities that are not part of model execution
architecture. Models should not depend on these unless the utility is promoted
to an explicitly owned area.

## Adding a macro

- Put study-specific SQL in a model first.
- Extract a macro only when the behavior is genuinely reusable.
- Use one public macro per file.
- Put it under `pipeline/` only when the pipeline itself depends on it.
- Do not give a new macro the same name as an existing macro; dbt macro names
  are global even when files live in different directories.
