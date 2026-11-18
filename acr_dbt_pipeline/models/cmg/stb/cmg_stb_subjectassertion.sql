{{ config(materialized='table') }}

select
  null::text as "assertion_id",
  null::text as "subject_id",
  null::text as "encounter_id",
  null::text as "asserter_type",
  null::text as "assertion_source_type",
  null::text as "age_at_assertion",
  null::text as "age_at_event",
  null::text as "age_at_resolution",
  null::text as "concept_source",
  null::text as "value_number",
  null::text as "value_source",
  null::text as "value_unit",
  null::text as "value_unit_source",
  null::text as "access_policy_id",
  null::text as "study_id"
where 1 = 0
