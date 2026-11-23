

select
    assertion_id::text as "assertion_id",
    subject_id::text as "subject_id",
    null::text as "encounter_id",
    null::text as "asserter_type",
    null::text as "assertion_source_type",
    null::integer as "age_at_assertion",
    null::integer as "age_at_event",
    null::integer as "age_at_resolution",
    concept_source::text as "concept_source",
    null::numeric as "value_number",
    null::text as "value_source",
    null::text as "value_unit",
    null::text as "value_unit_source",
    access_policy_id::text as "access_policy_id",
    study_id::text as "study_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject_assertions"