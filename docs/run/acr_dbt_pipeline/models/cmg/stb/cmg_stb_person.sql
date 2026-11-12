
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_person__dbt_tmp" as (
    select distinct
    person_gid::text as "person_id",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
where subject_gid is not null
  );
