
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_person_external_id__dbt_tmp"
  
    
    as (
      select distinct
    person_gid::text as "person_person_id",
    subject_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
where subject_id is not null
    );
    
  