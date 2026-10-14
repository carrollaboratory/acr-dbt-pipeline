{{ config(materialized='table', schema='gregor_synthetic_data') }}

select 
  NULL::text as "file_id",
  NULL::text as "subject_id"