{{ config(materialized='table', schema='cmg_yale_data') }}

select 
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "has_access_policy",
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "id"
  NULL::text as "has_access_policy",
  NULL::text as "id"