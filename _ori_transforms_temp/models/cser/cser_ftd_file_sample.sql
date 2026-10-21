{{ config(materialized='table', schema='cser_data') }}

select 
  NULL::text as "file_id",
  NULL::text as "sample_id"