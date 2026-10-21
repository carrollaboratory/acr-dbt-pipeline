{{
  config(
    enabled = src_enabled('cmg_yale_ds_rared', 'subject'),
    tags = src_tags('cmg_yale_ds_rared')
  )
}}
{%- set snapshot = 'cmg_yale_ds_rared' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'participant') -%}
{%- set rename_map = {'participant_id': 'subject_id'} -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
select
  {{ normalize_parquet_columns(raw_path, rename_map=rename_map, source_alias='raw') }},
  cast('{{ snapshot }}' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
from raw
