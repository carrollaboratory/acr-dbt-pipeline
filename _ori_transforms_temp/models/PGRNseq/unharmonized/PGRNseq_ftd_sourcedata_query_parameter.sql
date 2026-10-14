{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "sourcedata_id",
NULL::text as "query_parameter"
