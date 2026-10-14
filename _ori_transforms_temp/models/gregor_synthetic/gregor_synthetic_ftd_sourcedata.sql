{{ config(materialized='table', schema='gregor_synthetic_data') }}

select 
  NULL::text as "data_source",
  NULL::text as "has_access_policy",
  NULL::text as "id"