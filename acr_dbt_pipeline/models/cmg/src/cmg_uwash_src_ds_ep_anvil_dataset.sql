{{
  config(
    enabled = src_enabled('cmg_uwash_ds_ep', 'anvil_dataset'),
    tags = src_tags('cmg_uwash_ds_ep')
  )
}}
{%- set snapshot = 'cmg_uwash_ds_ep' -%}
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
