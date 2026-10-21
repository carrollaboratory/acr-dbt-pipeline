{{ config(materialized='table', schema='cmg_yale_data') }}

select 
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "datasource_id",
  NULL::text as "datasource_id",
  NULL::text as "external_id"