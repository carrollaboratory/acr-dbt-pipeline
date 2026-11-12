{%- set subject_cols = [
  'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor',
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group', 'sequencing_center'
] -%}

with base as (
select
  {{ dbt_utils.star(ref('cmg_main_sample'), relation_alias='sa', except=subject_cols) }},
  {% for col in subject_cols -%}
  s."{{ col }}",
  {% endfor -%}
  {{ generate_global_id(prefix='sa', descriptor=['sa.subject_id','sa.sample_id','s.consent_group']) }}::text as sample_gid,
  concat('subject_id|sample id|consent_group:sa-[', sa."subject_id", '|', sa."sample_id", '|', s."consent_group", ']') AS sample_id_descriptor
from {{ ref('cmg_main_sample') }} sa
left join (
select distinct
  subject_id,
  {{ subject_cols | join(',\n  ') }}
from {{ ref("cmg_int_subject") }} ) s
using (subject_id)
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

