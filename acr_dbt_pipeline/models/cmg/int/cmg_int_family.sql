with base as ( -- join to dataset metadata (anvil_dataset)
select
  f.*,
  ad.*,
  {{ generate_global_id(prefix='fy', descriptor=["family_id"]) }}::text  as family_gid,
  {{ generate_global_id(prefix='st', descriptor=["registered_identifier"]) }}::text  as study_gid,
  {{ generate_global_id(prefix='co', descriptor=["consent_group"]) }}::text  as access_policy_gid,
  concat('family id:fy-[', "family_id", ']') AS family_id_descriptor,
  concat('registered_identifier:st-[', "registered_identifier", ']') AS study_id_descriptor,
  concat('consent_group:co-[', "consent_group", ']') AS access_policy_descriptor,
from {{ ref('cmg_main_family') }} f
left join {{ ref("cmg_int_anvil_dataset")}} ad
using(source_snapshot_id)
),
consanguinity_mappings as (
select 
code::text as consanguinity,
mapped_code::text as consanguinity_code
from {{ ref("cmg_data_model_mappings") }}
where code_system = 'https://anvilproject.org//consanguinity'
),
family_history_mappings as (
select 
code::text as family_history,
mapped_code::text as family_history_code
from {{ ref("cmg_data_model_mappings") }}
where code_system = 'https://anvilproject.org//family_history'
)
select -- join the annotations
  base.*,
  consanguinity_code::text as consanguinity_code,
  family_history_code::text as family_history_code,
  from base
  left join consanguinity_mappings
  using (consanguinity)
  left join family_history_mappings
  using (family_history)

