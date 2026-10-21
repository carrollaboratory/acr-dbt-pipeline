{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "subject_id",
  subject_id::text as "external_id"
from (select distinct subject_id from {{ ref('cmg_bh_stg_subject') }} ) as s