{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "code",
NULL::text as "display",
NULL::text as "value_code",
NULL::text as "value_display",
NULL::text as "id"
