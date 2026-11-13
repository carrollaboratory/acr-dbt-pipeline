
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_participant_lifespan_stage__dbt_tmp" as (
    select
    studymetadata_study_id::text as "studymetadata_study_id",
    participant_lifespan_stage::text as "participant_lifespan_stage"
  );
