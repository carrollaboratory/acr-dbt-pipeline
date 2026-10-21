{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "code",
null::text as "display",
null::text as "value_code",
null::text as "value_display",
null::text as "id"