select distinct
  family_gid::text as "family_id",
  cast(null as text) as "family_type",
  cast(null as text) as "family_description",
  consanguinity::text as "consanguinity",
  cast(null as text) as "family_study_focus",
  access_policy_gid::text as "access_policy_id",
  study_gid::text as "study_id"
from {{ ref('cmg_int_family') }}
where family_id is not null