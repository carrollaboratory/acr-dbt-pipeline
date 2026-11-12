
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing__dbt_tmp"
  
    
    as (
      with base as (
select
seq.*, sa.*,
'ay' || '_' || md5(cast(coalesce(sequencing_id, '') as text) || '|' || cast(coalesce(consent_group, '') as text))::text as assay_id_gid,
concat('sequencing_id|consent_group:ay-[', "sequencing_id", '|', "consent_group", ']') AS assay_id_descriptor,
from "acr_dbt_pipeline"."main_cmg"."cmg_main_sequencing" seq
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
from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample" ) sa
using (sample_id)
)
  
select -- join the annotations
  base.*
from base
    );
    
  