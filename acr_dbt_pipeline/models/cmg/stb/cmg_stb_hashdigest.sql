{{ config(materialized='table') }}

select
  null::text as "id",
  null::text as "hash_type",
  null::text as "hash_value"
where 1 = 0
