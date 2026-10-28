
select
  f.*, ad.*,
  {{ generate_global_id(prefix='fy', descriptor=['family_id']) }}::text  as family_gid,
  {{ generate_global_id(prefix='st', descriptor=['registered_identifier']) }}::text  as study_gid,
  {{ generate_global_id(prefix='co', descriptor=['consent_group']) }}::text  as access_policy_gid
from {{ ref('cmg_main_family') }} f
left join {{ ref("cmg_int_anvil_dataset")}} ad
using(source_snapshot_id , source_snapshot)
