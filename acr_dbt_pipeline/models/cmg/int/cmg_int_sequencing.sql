select
seq.*, ad.*, s.subject_id, s.sequencing_center,
{{ generate_global_id(prefix='sb', descriptor=['sample_id','consent_group']) }}::text  as assay_id_gid,
{{ generate_global_id(prefix='sb', descriptor=['sample_id','consent_group']) }}::text  as sample_gid,
{{ generate_global_id(prefix='st', descriptor=['registered_identifier']) }}::text  as study_gid,
{{ generate_global_id(prefix='co', descriptor=['consent_group']) }}::text  as access_policy_gid
from {{ ref('cmg_main_sequencing') }} seq
left join {{ ref("cmg_int_anvil_dataset")}} ad
using(source_snapshot_id , source_snapshot)
left join (select subject_id, sample_id from{{ ref("cmg_main_subject")}}) s
using(sample_id)