{{ config(materialized='table') }}

select
  null::text as "vocabulary_prefix",
  null::text as "name",
  null::text as "vocabulary_uri",
  null::text as "vocabulary_id",
  null::text as "fhir_system",
  null::text as "description",
  null::text as "version",
  null::text as "vocabulary_source"
where 1 = 0
