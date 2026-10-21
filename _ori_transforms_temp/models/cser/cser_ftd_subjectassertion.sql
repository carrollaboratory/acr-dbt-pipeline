{{ config(materialized='table', schema='cser_data') }}


with hpo_codes as (
    select 
    subject_id,
    consent_id,
    UNNEST(IFNULL(SPLIT(hpo_present, '|'),[NULL])) as code,
    'LA9633-4'::text as "value_code",
    'Present'::text as "value_display"
    from (select distinct subject_id, consent_id, hpo_present from {{ ref('cser_stg_subject') }})
    
    union all
    
    select 
    subject_id,
    consent_id,
    UNNEST(IFNULL(SPLIT(hpo_absent, '|'),[NULL])) as code,
    'LA9634-2'::text as "value_code",
    'Absent'::text as "value_display"
    from (select distinct subject_id, consent_id, hpo_absent from {{ ref('cser_stg_subject') }})
)

select
'phenotypic_feature'::text as "assertion_type",
NULL::text as "age_at_assertion",
NULL::text as "age_at_event",
NULL::text as "age_at_resolution",
ca.response_code as "code",
ca.display::text as "display",
hc.value_code,
hc.value_display,
NULL::text as "value_number",
NULL::text as "value_units",
NULL::text as "value_units_display",
    {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sa',descriptor=['subject_id','response_code'], study_id='cser') }}::text as "id",
    {{ generate_global_id(prefix='sb',descriptor=['subject_id','consent_id'], study_id='cser') }}::text as "subject_id"
from hpo_codes as hc
join {{ ref('cser_annotations') }} as ca
    on hc.code = ca.searched_code
where hc.code is not null