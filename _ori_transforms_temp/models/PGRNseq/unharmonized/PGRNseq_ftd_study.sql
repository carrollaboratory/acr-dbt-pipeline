{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "parent_study_id",
NULL::text as "study_title",
NULL::text as "id"
