{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "study_id",
NULL::text as "funding_source"
