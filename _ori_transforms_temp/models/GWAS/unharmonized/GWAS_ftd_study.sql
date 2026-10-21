{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "parent_study_id",
null::text as "study_title",
null::text as "id"