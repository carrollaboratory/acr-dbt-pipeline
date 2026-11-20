select
    assertion_id::text as "subjectassertion_assertion_id",
    value_concept_curie::text as "value_concept_concept_curie"
from {{ ref('cmg_int_subject_assertions') }}
where value_concept_curie is not null
