with base as ( -- join to dataset metadata (anvil_dataset)
select
  {{ dbt_utils.star(ref('cmg_main_family'), relation_alias='f') }},
  {{ dbt_utils.star(ref('cmg_int_anvil_dataset'), relation_alias='ad', except=['source_snapshot_id', 'source_snapshot']) }},
  {{ generate_global_id(prefix='fy', descriptor=["family_id"]) }}::text  as family_gid,
  concat('family id:fy-[', "family_id", ']') AS family_id_descriptor
from {{ ref('cmg_main_family') }} f
left join {{ ref("cmg_int_anvil_dataset")}} ad
using(source_snapshot_id)
),
consanguinity_mappings as (
select 
source_text::text as consanguinity,
mapped_code::text as consanguinity_mapped_code
from {{ ref("mapdragon_annotations_talon") }}
where source_system = 'https://anvilproject.org//consanguinity'
),
family_history_mappings as (
select 
source_text::text as family_history,
mapped_code::text as family_history_mapped_code
from {{ ref("mapdragon_annotations_talon") }}
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

