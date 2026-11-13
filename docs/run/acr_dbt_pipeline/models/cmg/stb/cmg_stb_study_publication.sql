
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_publication__dbt_tmp" as (
    select
    study_study_id::text as "study_study_id",
    publication_id::integer as "publication_id"
  );
