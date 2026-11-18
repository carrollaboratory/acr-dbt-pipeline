{{ config(materialized='table') }}

select
  null::text as "id",
  null::text as "concept_curie",
  null::text as "display",
  null::text as "display_type",
  null::text as "language"
where 1 = 0
