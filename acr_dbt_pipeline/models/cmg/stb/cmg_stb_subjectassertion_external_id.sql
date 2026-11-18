{{ config(materialized='table') }}

select
  null::text as "subjectassertion_assertion_id",
  null::text as "external_id"
where 1 = 0
