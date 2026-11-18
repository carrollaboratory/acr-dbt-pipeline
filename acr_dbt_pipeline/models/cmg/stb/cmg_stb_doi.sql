{{ config(materialized='table') }}

select
  null::text as "do_id",
  null::text as "bibliographic_reference",
  null::text as "access_policy_id",
  null::text as "study_id"
where 1 = 0
