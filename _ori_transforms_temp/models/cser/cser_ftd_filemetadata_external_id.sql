{{ config(materialized='table', schema='cser_data') }}

with unioned_names as (
        select
            distinct 
            file_id as "file_id"
        from {{ ref('cser_stg_file_inventory') }}
    
        union all
   
        select
            distinct 
            sequencing_id as "file_id"
        from {{ ref('cser_stg_sequencing') }}
)

select
  {{ generate_global_id(prefix='fd',descriptor=['file_id'], study_id='cser') }}::text as "filemetadata_id",
  file_id::text as "external_id"
from {{ ref('cser_stg_file_inventory') }} as file_inventory