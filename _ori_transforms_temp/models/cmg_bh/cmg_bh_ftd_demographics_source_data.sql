{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "demographics_id",
  {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "source_data_id"
from (select distinct subject_id, dbgap_study_id from {{ ref('cmg_bh_stg_subject') }} ) as s