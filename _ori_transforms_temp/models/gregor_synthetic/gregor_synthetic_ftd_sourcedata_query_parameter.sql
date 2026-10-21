{{ config(materialized='table', schema='gregor_synthetic_data') }}

select 
  NULL::text as "sourcedata_id",
  NULL::text as "query_parameter"
