{{ config(materialized='table', schema='cser_data') }}

select 
  {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "sourcedata_id",
  dbgap_study_id::text as "external_id"
from (select distinct dbgap_study_id, consent_id 
      from {{ ref('cser_stg_subject') }}
      ) as s