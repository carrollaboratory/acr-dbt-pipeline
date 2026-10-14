{{ config(materialized='table', schema='PGRNseq_data') }}

select 
  NULL::text as "accesspolicy_id",
  NULL::text as "data_access_type"
