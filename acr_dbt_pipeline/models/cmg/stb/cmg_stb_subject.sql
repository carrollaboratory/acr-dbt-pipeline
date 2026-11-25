select distinct
    subject_gid::text as "subject_id",
    subject_type_concept_curie::text as "subject_type",
    organism_type_concept_uri_or_curie::text as "organism_type",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
where subject_id is not null
