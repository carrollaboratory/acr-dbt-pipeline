{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  distinct
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "data_source",
  {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cmg_yale') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='sd',descriptor=['project_id'], study_id='cmg_yale') }}::text as "id",
  project_id as "ftd_project_id",
  NULL::text as "data_source"
  from (select distinct project_id, consent_id from {{ ref('cmg_yale_stg_subject') }} ) AS s