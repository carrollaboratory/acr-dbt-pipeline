{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='ap',descriptor=['s.consent_id'], study_id='cser') }}::text as "accesspolicy_id",
  data_access_type::text as "data_access_type"
from {{ ref('cser_stg_subject') }} as s
left join {{ ref('ap_access_policy') }} as ap
on lower(s.consent_id) = lower(ap.consent_code)
