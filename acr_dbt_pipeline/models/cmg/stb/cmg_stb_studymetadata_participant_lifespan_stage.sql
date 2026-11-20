{{ config(materialized='table') }}

select
  null::text as "studymetadata_study_id",
  null::text as "participant_lifespan_stage"
where 1 = 0
