{{ config(materialized='table') }}

select
  null::text as "study_study_id",
  null::text as "publication_id"
where 1 = 0
