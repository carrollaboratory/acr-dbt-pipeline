{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  {{ generate_global_id(prefix='ds',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "data_source",
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='sd',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "id"
from (select distinct dbgap_study_id, ingest_provenance from {{ ref('cmg_bh_stg_subject') }} ) as s
