
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_study_design__dbt_tmp" as (
    select
    studymetadata_study_id::text as "studymetadata_study_id",
    study_design_concept_curie::text as "study_design_concept_curie"
  );
