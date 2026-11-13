
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_external_id__dbt_tmp" as (
    select
    demographics_subject_id::text as "demographics_subject_id",
    external_id::text as "external_id"
  );
