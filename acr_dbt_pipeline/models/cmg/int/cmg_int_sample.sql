{%- set subject_cols = [
  'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor',
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group'
] -%}

with base as (
select
  {{ dbt_utils.star(ref('cmg_main_sample'), relation_alias='sa', except=subject_cols + ['sequencing_center']) }},
  {% for col in subject_cols -%}
  s."{{ col }}",
  {% endfor -%}
  -- most snapshots record sequencing_center on sample; uwash_ds_bdis records it on subject
  coalesce(sa."sequencing_center", s."subject_sequencing_center") as sequencing_center,
  {{ generate_global_id(prefix='sa', descriptor=['sa.subject_id','sa.sample_id','s.consent_group']) }}::text as sample_gid,
  concat('subject_id|sample id|consent_group:sa-[', sa."subject_id", '|', sa."sample_id", '|', s."consent_group", ']') AS sample_id_descriptor
from {{ ref('cmg_main_sample') }} sa
left join (
select distinct
  subject_id,
  source_snapshot_id,
  {{ subject_cols | join(',\n  ') }},
  sequencing_center as subject_sequencing_center
from {{ ref("cmg_int_subject") }} ) s
using (subject_id, source_snapshot_id)
),
sample_source_mappings as (
  select 
  source_text::text as sample_source,
  mapped_code::text as sample_source_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//sample_source'
  )
  
select -- join the annotations
  base.*,
  sample_source_mapped_code
from base
left join sample_source_mappings
using (sample_source)

