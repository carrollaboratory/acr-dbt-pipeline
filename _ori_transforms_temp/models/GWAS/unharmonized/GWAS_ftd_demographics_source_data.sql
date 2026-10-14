{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "demographics_id",
null::text as "source_data_id"