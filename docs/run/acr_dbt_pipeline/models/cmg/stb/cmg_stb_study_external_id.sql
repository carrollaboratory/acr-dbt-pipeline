
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_external_id__dbt_tmp" as (
    select
    study_study_id::text as "study_study_id",
    external_id::text as "external_id"
  );
