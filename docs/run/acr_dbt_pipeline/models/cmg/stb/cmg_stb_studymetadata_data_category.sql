
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_data_category__dbt_tmp" as (
    select
    studymetadata_study_id::text as "studymetadata_study_id",
    data_category_concept_curie::text as "data_category_concept_curie"
  );
