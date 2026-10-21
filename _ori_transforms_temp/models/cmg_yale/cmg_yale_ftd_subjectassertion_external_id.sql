{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  distinct
  {{ generate_global_id(prefix='sa',descriptor=['subject_id','condition_or_disease_code'], study_id='cmg_yale') }}::text as "subjectassertion_id",
  subject_id::text as "external_id"
from (select 
        distinct subject_id,condition_or_disease_code,
      from {{ ref('cmg_yale_stg_subject') }}
      ) as s