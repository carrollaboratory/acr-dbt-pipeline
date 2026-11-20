{{
  config(
    enabled = src_enabled('cmg_yale_ds_rared', 'sample'),
    tags = src_tags('cmg_yale_ds_rared')
  )
}}
{%- set snapshot = 'cmg_yale_ds_rared' -%}
{%- set raw_path = tdr_snapshot_path(snapshot, 'sample') -%}
with raw as (
  select *
  from read_parquet('{{ raw_path | replace("'", "''") }}')
)
-- this snapshot carries both subject_id and Participant_id; fill subject_id from Participant_id
select
  * exclude (subject_id, participant_id),
  coalesce(
    nullif(trim(cast(subject_id as varchar)), ''),
    nullif(trim(cast(participant_id as varchar)), '')
  ) as subject_id
from (
  select
    {{ normalize_parquet_columns(raw_path, source_alias='raw') }},
    cast('{{ snapshot }}' as varchar) as source_snapshot,
    cast('{{ tdr_snapshot_id(snapshot) }}' as varchar) as source_snapshot_id
  from raw
)
