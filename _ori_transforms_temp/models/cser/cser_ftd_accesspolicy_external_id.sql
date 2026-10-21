{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "accesspolicy_id",
  consent_id::text as "external_id"
from {{ ref('cser_stg_subject') }} as subject
