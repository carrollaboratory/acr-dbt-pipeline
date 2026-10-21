{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "family_id",
NULL::text as "family_relationships_id"
