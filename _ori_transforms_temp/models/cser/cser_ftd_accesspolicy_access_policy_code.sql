{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cser') }}::text as "accesspolicy_id",
  lower(consent_id)::text as "access_policy_code"
from {{ ref('cser_stg_subject') }} as s