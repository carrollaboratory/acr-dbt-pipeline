{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='ds',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "datasource_id",
  dbgap_study_id::text as "external_id"
from {{ ref('cser_stg_subject') }} as subject
