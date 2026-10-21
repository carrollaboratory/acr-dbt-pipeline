{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "filename",
NULL::text as "format",
NULL::text as "data_type",
NULL::integer as "size",
NULL::text as "drs_uri",
NULL::text as "file_metadata",
NULL::text as "has_access_policy",
NULL::text as "id"
