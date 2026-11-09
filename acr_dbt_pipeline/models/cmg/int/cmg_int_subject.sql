select 
  s.*,
  ad.*,
  {{ generate_global_id(prefix='fy', descriptor=["family_id"]) }}::text  as family_gid,

  concat('family id:fy-[', "family_id", ']') AS family_id_descriptor,
  concat('registered_identifier:st-[', "registered_identifier", ']') AS study_id_descriptor,
  concat('consent_group:co-[', "consent_group", ']') AS access_policy_descriptor,
  
  subject_gid::text as "subject_id",
  access_policy_gid::text as "access_policy_id",
  study_gid::text as "study_id"
  
from {{ ref("cmg_main_subject")}} s
left join {{ ref("cmg_main_anvil_dataset")}} ad
using(source_snapshot_id)
