{{
  config(
    enabled = src_enabled('cmg_broad_muscle_topf_wes', 'anvil_dataset'),
    tags = src_tags('cmg_broad_muscle_topf_wes')
  )
}}
{#-
  Source names are normalized to lower snake case. Add a rename_map override to
  normalize_parquet_columns only when Broad uses a semantically different name.
  cmg_main unions by name, so differing semantic names remain distinct columns.
-#}
{%- set snapshot = 'cmg_broad_muscle_topf_wes' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'anvil_dataset') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
select
  {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
  cast('{{ snapshot }}' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
from raw
