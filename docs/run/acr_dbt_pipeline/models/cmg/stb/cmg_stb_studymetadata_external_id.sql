
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_external_id__dbt_tmp" as (
    select
    studymetadata_study_id::text as "studymetadata_study_id",
    external_id::text as "external_id"
  );
