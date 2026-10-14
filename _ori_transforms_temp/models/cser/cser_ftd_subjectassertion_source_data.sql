{{ config(materialized='table', schema='cser_data') }}

with hpo_codes as (
    select
    subject_id,
    dbgap_study_id,
    UNNEST(IFNULL(SPLIT(hpo_present, '|'),[NULL])) as code,
    from (select distinct subject_id, dbgap_study_id, hpo_present from {{ ref('cser_stg_subject') }}) as hp
    
    union all
    
    select
    subject_id,
    dbgap_study_id,
    UNNEST(IFNULL(SPLIT(hpo_absent, '|'),[NULL])) as code,
    from (select distinct subject_id, dbgap_study_id, hpo_absent from {{ ref('cser_stg_subject') }}) as ha
)

select 
  {{ generate_global_id(prefix='sa',descriptor=['subject_id','response_code'], study_id='cser') }}::text as "subjectassertion_id",
    {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "source_data_id"
from hpo_codes as hc
join {{ ref('cser_annotations') }} as ca
    on hc.code = ca.searched_code
where hc.code is not null