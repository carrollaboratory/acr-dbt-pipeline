{{ config(materialized='table') }}

select
  null::text as "study_study_id",
  null::text as "program"
where 1 = 0
