{{
  config(
    enabled = src_enabled('cmg_broad_blood_fleming_wes_ds_bfd_mds', 'file_inventory'),
    tags = src_tags('cmg_broad_blood_fleming_wes_ds_bfd_mds')
  )
}}
{#-
  Source names are normalized to lower snake case. Add a rename_map override to
  normalize_parquet_columns only when Broad uses a semantically different name.
  cmg_main unions by name, so differing semantic names remain distinct columns.
-#}
{%- set snapshot = 'cmg_broad_blood_fleming_wes_ds_bfd_mds' -%}
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
