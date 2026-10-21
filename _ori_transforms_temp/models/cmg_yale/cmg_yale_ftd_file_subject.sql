{{ config(materialized='table', schema='cmg_yale_data') }}
with 
get_sids as (
  select crai as file, subject_id
  from {{ ref('cmg_yale_stg_sample') }}
  where crai is not null
    union all 
  select cram as file, subject_id 
  from {{ ref('cmg_yale_stg_sample') }}
  where cram is not null
)

select 
 distinct 
  {{ generate_global_id(prefix='fl',descriptor=['name'], study_id='cmg_yale') }}::text as "file_id",
  {{ generate_global_id(prefix='sm',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "subject_id"
from 
  get_sids
  left join {{ ref('cmg_yale_stg_file_inventory') }}
    on file = file_ref