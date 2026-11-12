
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_program__dbt_tmp" as (
    select
    study_study_id::text as "study_study_id",
    program::text as "program"
  );
