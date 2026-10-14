{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  distinct
  {{ generate_global_id(prefix='sm',descriptor=['subject_id','sample_id'], study_id='cmg_yale') }}::text as "sample_id",
  NULL::text as "storage_method"
from (select distinct subject_id,sample_id
      from {{ ref('cmg_yale_stg_sample') }}
      ) as sam