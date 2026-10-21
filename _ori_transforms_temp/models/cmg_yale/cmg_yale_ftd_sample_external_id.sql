{{ config(materialized='table', schema='cmg_yale_data') }}

select  
  distinct
  {{ generate_global_id(prefix='sm',descriptor=['subject_id','sample_id'], study_id='cmg_yale') }}::text as "sample_id",
  sample_id::text as "external_id"
from (select distinct subject_id, sample_id 
      from {{ ref('cmg_yale_stg_sample') }}
      ) as sam