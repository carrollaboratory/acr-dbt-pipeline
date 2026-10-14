{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "sample_id",
null::text as "processing"