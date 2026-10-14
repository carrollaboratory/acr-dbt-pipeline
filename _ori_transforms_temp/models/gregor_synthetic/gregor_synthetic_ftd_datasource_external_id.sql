{{ config(materialized='table', schema='gregor_synthetic_data') }}

select 
  NULL::text as "datasource_id",
  NULL::text as "external_id"
