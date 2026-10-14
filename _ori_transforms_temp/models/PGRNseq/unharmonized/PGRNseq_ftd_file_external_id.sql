{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "file_id",
NULL::text as "external_id"
