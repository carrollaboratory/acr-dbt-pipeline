{{ config(materialized='table', schema='cmg_yale_data') }}

select 
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "sourcedata_id",
  NULL::text as "sourcedata_id",
  NULL::text as "query_parameter"