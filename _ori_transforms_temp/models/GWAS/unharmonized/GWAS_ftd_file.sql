{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "filename",
null::text as "format",
null::text as "data_type",
null::integer as "size",
null:text as "drs_uri",
null::text as "file_metadata",
null::text as "has_access_policy",
null::text as "id"