{{ config(materialized='table') }}

select
  null::text as "virtualbiorepository_vbr_id",
  null::text as "external_id"
where 1 = 0
