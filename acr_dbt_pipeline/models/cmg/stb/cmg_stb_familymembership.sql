-- Derive the same family gid from family_id without joining the family model.
select distinct
    {{ generate_md5_global_id(prefix='fm', descriptor=['family_id', 'subject_id', 'consent_group']) }}::text as "family_membership_id",
    {{ generate_md5_global_id(prefix='fy', descriptor=['family_id']) }}::text as "family_id",
    subject_gid::text as "subject_id",
    proband_relationship_concept_curie::text as "family_role",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
where subject_id is not null
and family_id is not null
