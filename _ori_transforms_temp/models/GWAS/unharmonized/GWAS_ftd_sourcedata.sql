{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "data_source",
null::text as "has_access_policy",
null::text as "id"