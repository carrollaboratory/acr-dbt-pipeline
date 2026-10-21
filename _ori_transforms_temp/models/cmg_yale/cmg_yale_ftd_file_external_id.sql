{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='fl',descriptor=['name'], study_id='cmg_yale') }}::text as "file_id",
  name::text as "external_id"
from 
  {{ ref('cmg_yale_stg_file_inventory') }}