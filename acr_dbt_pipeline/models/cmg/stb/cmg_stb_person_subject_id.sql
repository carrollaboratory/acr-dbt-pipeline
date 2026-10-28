select distinct
    person_gid::text as "person_person_id",
    subject_gid::text as "subject_id_subject_id"
from {{ ref('cmg_int_subject') }}
