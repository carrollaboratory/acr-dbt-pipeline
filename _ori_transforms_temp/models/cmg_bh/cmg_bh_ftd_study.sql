{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  NULL::text as "parent_study_id",
  'Baylor Hopkins Center for Mendelian Genomics (BH CMG)' as "study_title", 
  {{ generate_global_id(prefix='st',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "id"
from (select distinct dbgap_study_id from {{ ref('cmg_bh_stg_subject') }}) s