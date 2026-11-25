{{ config(materialized='table') }}

select
  null::text as "publication_id",
  null::text as "external_id"
where 1 = 0
