{{ config(materialized='table', schema='PGRNseq_data') }}

select 
 NULL::text as "sample_id",
 NULL::text as "storage_method"
