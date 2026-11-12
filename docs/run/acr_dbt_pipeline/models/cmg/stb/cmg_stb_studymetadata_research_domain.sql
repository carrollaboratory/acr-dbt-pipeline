
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_research_domain__dbt_tmp" as (
    select
    studymetadata_study_id::text as "studymetadata_study_id",
    research_domain_concept_curie::text as "research_domain_concept_curie"
  );
