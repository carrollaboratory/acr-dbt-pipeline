{{ config(materialized='table') }}

select
  null::text as "studymetadata_study_id",
  null::text as "research_domain_concept_curie"
where 1 = 0
