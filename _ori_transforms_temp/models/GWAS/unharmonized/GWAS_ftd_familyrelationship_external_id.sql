{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "familyrelationship_id",
null::text as "external_id"