{{ config(materialized='table', schema='cmg_bh_data') }}

select
  distinct
  {{ generate_global_id(prefix='sa',descriptor=['subject_id','condition_or_disease_code'], study_id='cmg_bh') }}::text as "subjectassertion_id",
  {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "source_data_id"
from (select distinct subject_id, condition_or_disease_code, dbgap_study_id from {{ ref('cmg_bh_stg_subject') }} ) as s