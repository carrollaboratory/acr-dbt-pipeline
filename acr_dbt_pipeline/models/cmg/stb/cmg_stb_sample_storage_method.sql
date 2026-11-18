{{ config(materialized='table') }}

select
  null::text as "sample_sample_id",
  null::text as "storage_method"
where 1 = 0
