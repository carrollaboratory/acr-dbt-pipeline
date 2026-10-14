{{ config(materialized='table', schema='GWAS_data') }}

select 
  null::text as "has_access_policy",
    null::text as "id"
