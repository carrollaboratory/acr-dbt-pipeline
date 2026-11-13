
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_clinical_data_source_type__dbt_tmp" as (
    select
    studymetadata_study_id::text as "studymetadata_study_id",
    clinical_data_source_type::text as "clinical_data_source_type"
  );
