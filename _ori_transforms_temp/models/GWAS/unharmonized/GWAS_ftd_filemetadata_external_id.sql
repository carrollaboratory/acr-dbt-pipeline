{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "filemetadata_id",
null::text as "external_id"