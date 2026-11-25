{{ config(materialized='table') }}

select
  null::text as "investigator_id",
  null::text as "external_id"
where 1 = 0
