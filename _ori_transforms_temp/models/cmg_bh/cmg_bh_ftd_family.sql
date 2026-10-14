{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  NULL::text as "family_type",
  NULL::text as "family_description",
  NULL::text as "consanguinity",
  NULL::text as "family_study_focus",
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cmg_bh') }}::text as "id"
from (select distinct ingest_provenance, family_id from {{ ref('cmg_bh_stg_subject') }}) 