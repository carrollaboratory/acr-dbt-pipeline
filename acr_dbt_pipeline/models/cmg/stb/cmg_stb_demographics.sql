-- ancestry mappings, ethnicity codes go to ethnicity; the rest go to demographics_race
select distinct
    subject_gid::text as "subject_id",
    sex_concept_curie::text as "sex",
    case when regexp_full_match(trim(ancestry_mapped_code), '(?i:CDCREC:)?(2135-2|2186-5)')
        then ancestry_concept_curie end::text as "ethnicity",
    cast(null as integer) as "age_at_last_vital_status",
    cast(null as text) as "vital_status",
    cast(null as integer) as "age_at_first_engagement",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
where subject_id is not null
