{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "family_type",
null::text as "family_description",
null::text as "consanguinity",
null::text as "family_study_focus",
null::text as "has_access_policy",
null::text as "id"
