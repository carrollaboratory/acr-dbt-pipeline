{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cser') }}::text as "family_id",
  family_id::text as "external_id"
from {{ ref('cser_stg_subject') }} as subject
