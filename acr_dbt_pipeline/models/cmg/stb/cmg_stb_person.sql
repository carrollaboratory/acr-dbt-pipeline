select distinct
    person_gid::text as "person_id",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
where subject_gid is not null
