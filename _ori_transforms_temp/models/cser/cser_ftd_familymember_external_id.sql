{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='fm',descriptor=['family_id', 'subject_id', 'consent_id'], study_id='cser') }}::text as "familymember_id",
  subject_id::text as "external_id"
from {{ ref('cser_stg_subject') }} as subject
