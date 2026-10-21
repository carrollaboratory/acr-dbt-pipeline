{{ config(materialized='table', schema='cser_data') }}

select 
  NULL::text as "accesscontrolledrecord_id",
  NULL::text as "external_id"