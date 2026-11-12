with base as (
select
seq.*, sa.*,
{{ generate_global_id(prefix='ay', descriptor=['sequencing_id','consent_group']) }}::text as assay_id_gid,
concat('sequencing_id|consent_group:ay-[', "sequencing_id", '|', "consent_group", ']') AS assay_id_descriptor,
from {{ ref('cmg_main_sequencing') }} seq
left join (
select 
  distinct 
  sample_id,
  sample_gid,
  sample_id_descriptor,
  subject_id, 
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
from {{ ref("cmg_int_sample") }} ) sa
using (sample_id)
)
  
select -- join the annotations
  base.*
from base
