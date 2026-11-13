
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_principal_investigator__dbt_tmp" as (
    select
    study_study_id::text as "study_study_id",
    principal_investigator_id::integer as "principal_investigator_id"
  );
