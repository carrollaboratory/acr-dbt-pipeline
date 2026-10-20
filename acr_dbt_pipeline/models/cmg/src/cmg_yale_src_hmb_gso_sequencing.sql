{{
  config(
    enabled = src_enabled('cmg_yale_hmb_gso', 'sequencing'),
    tags = src_tags('cmg_yale_hmb_gso')
  )
}}
{#-
  Source names are normalized to lower snake case. Add a rename_map override to
  normalize_parquet_columns only when Yale uses a semantically different name.
  cmg_main unions by name, so differing semantic names remain distinct columns.
-#}
{%- set snapshot = 'cmg_yale_hmb_gso' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'sequencing') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
select
  {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
  cast('{{ snapshot }}' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
from raw
