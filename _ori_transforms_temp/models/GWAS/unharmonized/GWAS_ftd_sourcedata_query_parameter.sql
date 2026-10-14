{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "sourcedata_id",
null::text as "query_parameter"