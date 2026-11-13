{{
  config(
    enabled = src_enabled('cmg_yale_ds_mc', 'sample'),
    tags = src_tags('cmg_yale_ds_mc')
  )
}}
{%- set snapshot = 'cmg_yale_ds_mc' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'sample') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
-- this snapshot has no subject_id; build it from participant_id, then participant_id_2
select
  * exclude (participant_id, participant_id_2),
  coalesce(
    nullif(trim(cast(participant_id as varchar)), ''),
    nullif(trim(cast(participant_id_2 as varchar)), '')
  ) as subject_id
from (
  select
    {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
    cast('{{ snapshot }}' as varchar) as source_snapshot,
    cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
  from raw
)
