
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_contact__dbt_tmp" as (
    select
    study_study_id::text as "study_study_id",
    contact_id::integer as "contact_id"
  );
