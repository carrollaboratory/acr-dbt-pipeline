{{ config(materialized='table', schema='cser_data') }}

select 
  {{ generate_global_id(prefix='sb',descriptor=['subject_id','consent_id'], study_id='cser') }}::text as "subject_id",
  subject_id::text as "external_id"
from (select distinct subject_id, consent_id from {{ ref('cser_stg_subject') }}) as subject