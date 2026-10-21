{{
  config(
    enabled = src_enabled('cmg_uwash_ds_bdis', 'file_inventory'),
    tags = src_tags('cmg_uwash_ds_bdis')
  )
}}
{%- set snapshot = 'cmg_uwash_ds_bdis' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'file_inventory') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
select
  {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
  cast('{{ snapshot }}' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
from raw
