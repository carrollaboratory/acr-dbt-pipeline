{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  {{ generate_global_id(prefix='st',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "study_id",
  project_investigator::text as "principal_investigator"
from  (select distinct dbgap_study_id, project_investigator from {{ ref('cmg_bh_stg_subject') }}) as s