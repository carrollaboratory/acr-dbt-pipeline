with base as (
select
  sa.*, s.*,
  {{ generate_global_id(prefix='sa', descriptor=['s.subject_id','sa.sample_id','consent_group']) }}::text as sample_gid,
  concat('subject_id|sample id|consent_group:sa-[', s."subject_id", '|', sa."sample_id", '|', "consent_group", ']') AS sample_id_descriptor,
  s.person_id_descriptor,
  subject_id_descriptor,
  study_id_descriptor,
  access_policy_descriptor
from {{ ref('cmg_main_sample') }} sa
left join (
select 
  distinct subject_id, 
  subject_gid, 
  subject_id_descriptor,
  person_gid, 
  person_id_descriptor,
  study_gid,
  study_id_descriptor,
  access_policy_gid,
  access_policy_descriptor,
  consent_group,
  sequencing_center
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

