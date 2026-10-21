{{ config(materialized='table', schema='cser_data') }}

select 
  NULL::text as "family_id",
  NULL::text as "family_relationships_id"