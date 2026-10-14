{{ config(materialized='table', schema='cser_data') }}

select
  {{ generate_global_id(prefix='sm',descriptor=['subject_id','sample_id'], study_id='cser') }}::text as "sample_id",
  NULL::text as "processing"
from  (select distinct subject_id, sample_id 
      from {{ ref('cser_stg_sample') }}
      ) as sm