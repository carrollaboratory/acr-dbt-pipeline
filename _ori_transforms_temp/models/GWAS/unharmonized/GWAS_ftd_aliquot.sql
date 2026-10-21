{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "availablity_status",
null::text as "quantity_number",
null::text as "quantity_units",
null::text as "concentration_number",
null::text as "concentration_unit",
null::text as "has_access_policy",
null::text as "id",
null::text as "sample_id"
