{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  distinct
  {{ generate_global_id(prefix='fd',descriptor=['name'], study_id='cmg_yale') }}::text as "filemetadata_id",
  name::text as "external_id"
from {{ ref('cmg_yale_stg_file_inventory') }}