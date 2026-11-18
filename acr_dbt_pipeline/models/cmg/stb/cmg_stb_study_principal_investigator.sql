{{ config(materialized='table') }}

select
  null::text as "study_study_id",
  null::text as "principal_investigator_id"
where 1 = 0
