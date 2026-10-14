{{ config(materialized='table', schema='GWAS_data') }}

select 
null::integer as "age_at_collection",
null::text as "method",
null::text as "site",
null::text as "spatial_qualifier",
null::text as "laterality",
null::text as "has_access_policy",
null::text as "id"