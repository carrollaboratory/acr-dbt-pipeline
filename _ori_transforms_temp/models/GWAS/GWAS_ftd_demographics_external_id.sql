{{ config(materialized='table', schema='GWAS_data') }}

select 
  {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id'], study_id='phs001584') }}::text as "demographics_id",
  demographics.subject_id::text as "external_id"
from {{ ref('GWAS_stg_demographics') }} as demographics
