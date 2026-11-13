
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_race__dbt_tmp" as (
    select
    demographics_subject_id::text as "demographics_subject_id",
    race_concept_curie::text as "race_concept_curie"
  );
