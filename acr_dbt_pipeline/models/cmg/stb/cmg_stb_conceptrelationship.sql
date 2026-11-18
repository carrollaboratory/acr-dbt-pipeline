{{ config(materialized='table') }}

select
  null::text as "id",
  null::text as "concept_curie",
  null::text as "target_concept_curie",
  null::text as "relationship_curie"
where 1 = 0
