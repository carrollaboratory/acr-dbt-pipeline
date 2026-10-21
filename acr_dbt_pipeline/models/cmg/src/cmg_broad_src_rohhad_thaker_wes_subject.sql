{{
  config(
    enabled = src_enabled('cmg_broad_rohhad_thaker_wes', 'subject'),
    tags = src_tags('cmg_broad_rohhad_thaker_wes')
  )
}}
{%- set snapshot = 'cmg_broad_rohhad_thaker_wes' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'subject') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
select
  {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
  cast('{{ snapshot }}' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
from raw
