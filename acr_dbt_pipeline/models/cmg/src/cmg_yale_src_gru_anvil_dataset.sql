{{
  config(
    enabled = src_enabled('cmg_yale_gru', 'anvil_dataset'),
    tags = src_tags('cmg_yale_gru')
  )
}}
{#-
  Source names are normalized to lower snake case. Values are not cleaned here:
  cmg_main unions the snapshots first, then cmg_int cleans the result once.
-#}
{%- set snapshot = 'cmg_yale_gru' -%}
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
