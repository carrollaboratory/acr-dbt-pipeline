{{ config(materialized='table', schema='gregor_synthetic_data') }}

select 
 NULL::text as "demographics_id",
 NULL::text as "source_data_id"