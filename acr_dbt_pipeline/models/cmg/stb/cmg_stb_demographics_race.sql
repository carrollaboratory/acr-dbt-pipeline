select distinct
    subject_gid::text as "demographics_subject_id",
    ancestry_concept_curie::text as "race_concept_curie"
from {{ ref('cmg_int_subject') }}
where subject_id is not null
and ancestry_concept_curie is not null
and not regexp_full_match(trim(ancestry_mapped_code), '(?i:CDCREC:)?(2135-2|2186-5)')
