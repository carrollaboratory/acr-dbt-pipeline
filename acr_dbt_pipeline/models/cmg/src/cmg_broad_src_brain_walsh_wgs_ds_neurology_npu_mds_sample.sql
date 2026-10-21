{{
  config(
    enabled = src_enabled('cmg_broad_brain_walsh_wgs_ds_neurology_npu_mds', 'sample'),
    tags = src_tags('cmg_broad_brain_walsh_wgs_ds_neurology_npu_mds')
  )
}}
{%- set snapshot = 'cmg_broad_brain_walsh_wgs_ds_neurology_npu_mds' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'sample') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
select
  {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
  cast('{{ snapshot }}' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
from raw
