{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='sb',descriptor=['subject_id', 'consent_id'], study_id='cser') }}::text as "family_member",
  NULL::text as "family_role",
  {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='fm',descriptor=['family_id', 'subject_id', 'consent_id'], study_id='cser') }}::text as "id",
  {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cser') }}::text as "family_id"
from {{ ref('cser_stg_subject') }} as subject