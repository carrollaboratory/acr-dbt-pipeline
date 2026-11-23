-- Derive the same family gid from family_id without joining the family model.
select distinct
    'fm' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(family_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as "family_membership_id",
    'fy' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(family_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as "family_id",
    subject_gid::text as "subject_id",
    proband_relationship_mapped_code::text as "family_role",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
where subject_id is not null
and family_id is not null