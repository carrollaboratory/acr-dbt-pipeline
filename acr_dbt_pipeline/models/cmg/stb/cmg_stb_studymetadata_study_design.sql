{{ config(materialized='table') }}

select
  null::text as "studymetadata_study_id",
  null::text as "study_design_concept_curie"
where 1 = 0
