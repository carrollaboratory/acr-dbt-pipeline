{{
  config(
    enabled = src_enabled('cmg_broad_muscle_kang_wgs', 'subject'),
    tags = src_tags('cmg_broad_muscle_kang_wgs')
  )
}}
{%- set snapshot = 'cmg_broad_muscle_kang_wgs' -%}
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
