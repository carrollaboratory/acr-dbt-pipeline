# Raw source ingestion

Architecture-owned macros for resolving local TDR Parquet exports.

Harmonizers should:

- configure snapshots under `vars.tdr_parquet_sources`;
- select snapshots through `vars.enabled_srcs`;
- use `normalize_parquet_columns()` in a `src` model to produce lower snake-case
  column names from the Parquet schema;
- pass a `rename_map` only when a source column needs an explicit naming override.

Do not add study-specific value cleaning here. Source models align names and
preserve stored values; shared value cleaning belongs to the `int` stage.

`normalize_parquet_columns(path, source_alias='raw')` reads names from the
Parquet schema (not from the CTE) and emits qualified aliases in source order.
It converts names like `PrincipalInvestigator` and `Dataset ID` to
`principal_investigator` and `dataset_id`. Use `rename_map` only for an explicit
semantic override; collisions fail instead of silently merging names.
