{{ config(materialized='table', schema='cser_data') }}

select 
  {{ generate_global_id(prefix='ds',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "data_source",
    {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "id"
from  (select distinct dbgap_study_id, consent_id 
      from {{ ref('cser_stg_subject') }}
      ) as s
