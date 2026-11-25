-- ancestry mappings, ethnicity codes go to ethnicity; the rest go to demographics_race
select distinct
    subject_gid::text as "subject_id",
    sex_concept_curie::text as "sex",
    case when ancestry_concept_curie in ('CDCREC:2135-2','CDCREC:2186-5','snomedct:261665006','snomedct:74964007')
        then ancestry_concept_curie 
        else 'snomedct:261665006' 
        end::text as "ethnicity",
    cast(null as integer) as "age_at_last_vital_status",
    cast(null as text) as "vital_status",
    cast(null as integer) as "age_at_first_engagement",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_subject') }}
where subject_id is not null
