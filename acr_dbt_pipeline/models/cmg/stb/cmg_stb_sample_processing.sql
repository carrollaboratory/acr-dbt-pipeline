{{ config(materialized='table') }}

select
  null::text as "sample_sample_id",
  null::text as "processing"
where 1 = 0
