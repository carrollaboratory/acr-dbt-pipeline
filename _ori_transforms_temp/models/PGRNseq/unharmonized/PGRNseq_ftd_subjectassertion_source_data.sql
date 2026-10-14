{{ config(materialized='table', schema='PGRNseq_data') }}

select 
  NULL::text as "subjectassertion_id",
  NULL::text as "source_data_id"
