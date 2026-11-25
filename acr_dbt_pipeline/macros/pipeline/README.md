# Pipeline architecture macros

The macros in this directory implement shared pipeline behavior. They are
architecture-owned: harmonizers should configure or call them, but should not
modify, copy, or override them for a single study or consent.

Changing a pipeline macro changes every model that depends on it. If a study
needs special handling, put that logic in its `src`, `int`, or `stb` model, or
add a harmonizer-facing macro outside `macros/pipeline/`.

dbt loads macros recursively and macro names are global. The directories below
are ownership boundaries for people; they do not create dbt namespaces.

## Macros copied from dbt_pipeline_utils

ACR does not import the `dbt_pipeline_utils` package. Macros it uses from
there (md5 global ids and descriptors, schema naming, profiling,
`normalize_curie`) are local copies. Each copied file starts with an
`Originally sourced from dbt_pipeline_utils (...)` note naming its source
file. Call them without a namespace, e.g. `generate_md5_global_id(...)`.
They are kept in sync by hand: when you change one here, consider making the
same change in `dbt-pipeline-utils`, and the reverse.

## Responsibilities

| Directory | Responsibility |
| --- | --- |
| `raw_source_ingestion/` | Resolve configured TDR snapshots and local Parquet files; optionally generate source column projections |
| `source_selection/` | Validate `enabled_srcs`, enable source models, derive tags, and enforce source model naming |
| `main_stage/` | Combine selected, name-aligned source models |
| `int_stage/` | Apply shared value-cleaning behavior after source union |
| `shared/` | Small internal helpers required by more than one pipeline stage |
| `identifiers/` | md5 global ids and their analysis descriptors (copied from dbt_pipeline_utils) |
| `warehouse_naming/` | `generate_schema_name` (copied from dbt_pipeline_utils `schema_name_from_path`) |
| `relation_metadata/` | Shared relation introspection |

## File convention

Use one public macro per SQL file. A private helper may share a file only when
it is inseparable from that macro and has no independent callers. Prefer a
separate file when a helper has its own responsibility or is reused elsewhere.
Groups copied from dbt_pipeline_utils (e.g. `identifiers/identifiers.sql`)
keep the source's grouping so they stay easy to compare.

When changing an architecture macro:

1. Search every call site.
2. Preserve the public macro signature unless all callers are migrated.
3. Update `_macros.yml` and the relevant quickstart.
4. Run `dbt parse --no-partial-parse` and the smallest downstream model set.
