{{ config(materialized='table', schema='cser_data') }}

select 
  {{ generate_global_id(prefix='st',descriptor=['dataset_id'], study_id='cser') }}::text as "study_id",
  principal_investigator::text as "principal_investigator"
from (select distinct dataset_id, principal_investigator from {{ ref('cser_stg_anvil_dataset') }}) as ad