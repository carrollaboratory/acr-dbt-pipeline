with base as ( -- join to dataset metadata (anvil_dataset)
select
  f.*,
  ad.*,
  'fy' || '_' || md5(cast(coalesce(family_id, '') as text))::text  as family_gid,
  study_gid,
  access_policy_gid,
  concat('family id:fy-[', "family_id", ']') AS family_id_descriptor,
  study_id_descriptor,
  access_policy_descriptor,
from "acr_dbt_pipeline"."main_cmg"."cmg_main_family" f
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset" ad
using(source_snapshot_id)
),
consanguinity_mappings as (
select 
source_text::text as consanguinity,
mapped_code::text as consanguinity_mapped_code
from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
where source_system = 'https://anvilproject.org//consanguinity'
),
family_history_mappings as (
select 
source_text::text as family_history,
mapped_code::text as family_history_mapped_code
from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
where source_system = 'https://anvilproject.org//family_history'
)
select -- join the annotations
  base.*,
  consanguinity_mapped_code::text as consanguinity_mapped_code,
  family_history_mapped_code::text as family_history_mapped_code,
  from base
  left join consanguinity_mappings
  using (consanguinity)
  left join family_history_mappings
  using (family_history)