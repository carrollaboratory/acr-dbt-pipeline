select distinct
    subject_gid::text as "subject_id",
    'CAMO:0000024'::text as "subject_type",
    'NCBITaxon:9606'::text as "organism_type",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
where subject_id is not null
