{{ config(materialized='table', schema='cser_data') }}

select 
  'phs002307'::text as "parent_study_id",
  title::text as "study_title",
    {{ generate_global_id(prefix='st',descriptor=['dataset_id'], study_id='cser') }}::text as "id"
from (select distinct title, dataset_id from {{ ref('cser_stg_anvil_dataset') }}) as ad