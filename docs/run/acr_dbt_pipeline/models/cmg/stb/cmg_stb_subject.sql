
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_subject__dbt_tmp"
  
    
    as (
      select distinct
    subject_gid::text as "subject_id",
    subject_type_concept_curie::text as "subject_type",
    organism_type_concept_uri_or_curie::text as "organism_type",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
where subject_id is not null
    );
    
  