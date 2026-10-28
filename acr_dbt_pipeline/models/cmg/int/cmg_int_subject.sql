select
s.*, ad.*, subject_id as person_id,
{{ generate_global_id(prefix='sb', descriptor=['subject_id','consent_group']) }}::text  as subject_gid,
{{ generate_global_id(prefix='pr', descriptor=['subject_id','consent_group']) }}::text  as person_gid,
{{ generate_global_id(prefix='fy', descriptor=['family_id']) }}::text  as family_gid,
{{ generate_global_id(prefix='st', descriptor=['registered_identifier']) }}::text  as study_gid,
{{ generate_global_id(prefix='co', descriptor=['consent_group']) }}::text  as access_policy_gid
from {{ ref("cmg_main_subject")}} s
left join {{ ref("cmg_int_anvil_dataset")}} ad
using(source_snapshot_id , source_snapshot)
