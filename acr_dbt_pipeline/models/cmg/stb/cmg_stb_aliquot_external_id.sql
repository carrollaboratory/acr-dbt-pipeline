{{ config(materialized='table') }}

select
  null::text as "aliquot_aliquot_id",
  null::text as "external_id"
where 1 = 0
