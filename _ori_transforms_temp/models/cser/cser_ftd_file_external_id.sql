{{ config(materialized='table', schema='cser_data') }}

select distinct
  {{ generate_global_id(prefix='fl',descriptor=['file_id'], study_id='cser') }}::text as "file_id",
  file_id::text as "external_id"
from {{ ref('cser_stg_file_inventory') }} as file_inventory