{{ config(materialized='table') }}

select
  null::text as "concept_curie",
  null::text as "concept_id",
  null::text as "vocabulary_prefix",
  null::text as "concept_code",
  null::text as "display",
  null::text as "definition"
where 1 = 0
