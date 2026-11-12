select
  'cmg_int_family' as descriptor_source_table,
  family_gid,
  family_id_descriptor,
  study_gid,
  study_id_descriptor,
  access_policy_gid,
  access_policy_descriptor,
from "acr_dbt_pipeline"."main_cmg"."cmg_int_family"