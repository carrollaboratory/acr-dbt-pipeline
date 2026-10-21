{{ config(materialized='table', schema='cser_data') }}

select 
  {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "sourcedata_id",
  NULL::text as "query_parameter"
from (select distinct dbgap_study_id 
      from {{ ref('cser_stg_subject') }}
      ) as s