select distinct
    subject_gid::text as "subject_subject_id",
    subject_id::text as "external_id"
from {{ ref('cmg_int_subject') }}
