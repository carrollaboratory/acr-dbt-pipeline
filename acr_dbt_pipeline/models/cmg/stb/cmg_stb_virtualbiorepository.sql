{{ config(materialized='table') }}

select
  null::text as "vbr_id",
  null::text as "name",
  null::text as "institution",
  null::text as "website",
  null::text as "vbr_readme",
  null::text as "access_policy_id",
  null::text as "study_id"
where 1 = 0
