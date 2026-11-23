with base as (
select
  f."datarepo_row_id",
  f."family_id",
  f."consanguinity",
  f."ingest_provenance",
  f."source_snapshot",
  f."source_snapshot_id",
  f."family_history",
  f."pedigree_detail",
  f."pedigree_image",
  f."consanguinity_detail",
  ad."registered_identifier",
  ad."consent_group",
  ad."study_gid",
  ad."access_policy_gid",
  ad."study_id_descriptor",
  ad."access_policy_descriptor",
  'fy' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(family_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text  as family_gid,
  'family_id:fy-[' || coalesce(nullif(replace(regexp_replace(trim(cast(family_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as family_id_descriptor
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