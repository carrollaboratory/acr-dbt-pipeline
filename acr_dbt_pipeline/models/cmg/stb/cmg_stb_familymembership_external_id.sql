{{ config(materialized='table') }}

select
  null::text as "familymembership_family_membership_id",
  null::text as "external_id"
where 1 = 0
