{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "study_id",
null::text as "principal_investigator"