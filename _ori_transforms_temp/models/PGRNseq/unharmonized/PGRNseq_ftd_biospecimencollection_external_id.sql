{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "biospecimencollection_id",
NULL::text as "external_id"
