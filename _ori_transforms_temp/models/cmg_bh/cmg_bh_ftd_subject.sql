{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  distinct
  'participant'::text as "subject_type",
  'human'::text as "organism_type",
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "id",
  {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "has_demographics_id"
from (select distinct subject_id, ingest_provenance from {{ ref('cmg_bh_stg_subject') }} ) AS s