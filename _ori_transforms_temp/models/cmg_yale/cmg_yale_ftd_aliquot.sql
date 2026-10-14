{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  NULL::text as "availablity_status",
  NULL::text as "quantity_number",
  NULL::text as "quantity_units",
  NULL::text as "concentration_number",
  NULL::text as "concentration_unit",
  NULL::text as "has_access_policy",
  NULL::text as "id",
  NULL::text as "sample_id"
-- { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "has_access_policy",
-- { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "id",
-- { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "sample_id"