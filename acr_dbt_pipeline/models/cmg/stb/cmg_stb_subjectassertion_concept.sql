{{ config(materialized='table') }}

select
    assertion_id::text as "subjectassertion_assertion_id",
    concept_curie::text as "concept_concept_curie"
from {{ ref('cmg_int_subject_assertions') }}
where concept_curie is not null
