{{ config(materialized='table') }}

select
  null::text as "encounter_definition_id",
  null::text as "name",
  null::text as "description",
  null::text as "access_policy_id",
  null::text as "study_id"
where 1 = 0
