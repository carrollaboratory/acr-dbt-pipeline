{{ config(materialized='table') }}

select
  null::text as "subjectassertion_assertion_id",
  null::text as "concept_concept_curie"
where 1 = 0
