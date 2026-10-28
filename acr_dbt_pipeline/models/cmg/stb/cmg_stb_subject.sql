select distinct
    subject_gid::text as "subject_id",
    cast(null as text) as "subject_type",
    cast(null as text) as "organism_type",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
