{{ config(materialized='table', schema='cser_data') }}

select 
  {{ generate_global_id(prefix='st',descriptor=['dataset_id'], study_id='cser') }}::text as "study_id",
  'phs002307'::text as "external_id"
from (select distinct dataset_id from {{ ref('cser_stg_anvil_dataset') }}) as ad