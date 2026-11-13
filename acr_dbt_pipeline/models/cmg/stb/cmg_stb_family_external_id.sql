select distinct
  family_gid::text as "family_family_id",
  family_id::text as "external_id"
from {{ ref('cmg_int_family') }}
where family_id is not null
