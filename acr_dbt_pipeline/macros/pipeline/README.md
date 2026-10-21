# Pipeline architecture macros

The macros in this directory implement shared pipeline behavior. They are
architecture-owned: harmonizers should configure or call them, but should not
modify, copy, or override them for a single study or consent.

Changing a pipeline macro changes every model that depends on it. If a study
needs special handling, put that logic in its `src`, `int`, or `stb` model, or
add a harmonizer-facing macro outside `macros/pipeline/`.

dbt loads macros recursively and macro names are global. The directories below
are ownership boundaries for people; they do not create dbt namespaces.

## Responsibilities

| Directory | Responsibility |
| --- | --- |
| `raw_source_ingestion/` | Resolve configured TDR snapshots and local Parquet files; optionally generate source column projections |
| `source_selection/` | Validate `enabled_srcs`, enable source models, derive tags, and enforce source model naming |
| `main_stage/` | Combine selected, name-aligned source models |
| `int_stage/` | Apply shared value-cleaning behavior after source union |
| `shared/` | Small internal helpers required by more than one pipeline stage |
| `warehouse_naming/` | Global dbt schema and alias overrides |
| `relation_routing/` | Resolve model naming conventions into upstream refs |
| `relation_union/` | Generic pipeline relation collection and union behavior |
| `relation_metadata/` | Shared relation introspection |
| `identifiers/` | Shared identifier construction |
| `observability/` | Runtime warnings and pipeline monitoring |
| `docs/` | Quickstarts for imported/shared pipeline macros |

## File convention

Use one public macro per SQL file. A private helper may share a file only when
it is inseparable from that macro and has no independent callers. Prefer a
separate file when a helper has its own responsibility or is reused elsewhere.

When changing an architecture macro:

1. Search every call site.
2. Preserve the public macro signature unless all callers are migrated.
3. Update `_macros.yml` and the relevant quickstart.
4. Run `dbt parse --no-partial-parse` and the smallest downstream model set.
