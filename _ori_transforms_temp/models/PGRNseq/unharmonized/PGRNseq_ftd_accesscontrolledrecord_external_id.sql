{{ config(materialized='table', schema='PGRNseq_data') }}

select 
  NULL::text as "accesscontrolledrecord_id",
  NULL::text as "external_id"