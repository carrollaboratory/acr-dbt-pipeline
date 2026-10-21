{{ config(materialized='table', schema='cmg_yale_data') }}

select 
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "family_id",
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "family_relationships_id"  
  NULL::text as "family_id",
  NULL::text as "family_relationships_id"