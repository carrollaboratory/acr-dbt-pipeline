{{ config(materialized='table', schema='cmg_yale_data') }}
  
select 
  {{ generate_global_id(prefix='st',descriptor=['dbgap_study_id'], study_id='cmg_yale') }}::text as "study_id",
  {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "demographics_id",
  {{ generate_global_id(prefix='sd',descriptor=['project_id'], study_id='cmg_yale') }}::text as "source_data_id"
  
from (select distinct subject_id, project_id, dbgap_study_id 
      from {{ ref('cmg_yale_stg_subject') }} 
      where dbgap_study_id is not null) as s