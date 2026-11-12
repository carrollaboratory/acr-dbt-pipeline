with base as ( -- join the base table to anvil_dataset
  select 
    {{ dbt_utils.star(ref('cmg_main_subject'), relation_alias='s') }},
    {{ dbt_utils.star(ref('cmg_int_anvil_dataset'), relation_alias='ad', except=['source_snapshot_id', 'source_snapshot']) }},
    {{ generate_global_id(prefix='sb', descriptor=['subject_id','consent_group']) }}::text as subject_gid,
    concat('family id:sb-[', "subject_id", '|', "consent_group", ']') AS subject_id_descriptor,
    {{ generate_global_id(prefix='pr', descriptor=['subject_id','consent_group']) }}::text as person_gid,
    concat('family id:pr-[', "subject_id", '|', "consent_group", ']') AS person_id_descriptor,
  from {{ ref("cmg_main_subject")}} s
  left join {{ ref("cmg_int_anvil_dataset")}} ad
  using(source_snapshot_id)
  ),
  
affected_status_mappings as (
  select 
  source_text::text as affected_status,
  mapped_code::text as affected_status_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//affected_status'
  ),
ancestry_mappings as (
  select 
  source_text::text as ancestry,
  mapped_code::text as ancestry_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//ancestry'
  ), 
congenital_status_mappings as (
  select 
  source_text::text as congenital_status,
  mapped_code::text as congenital_status_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//congenital_status'
  ), 
dbgap_submission_mappings as (
  select 
  source_text::text as  dbgap_submission,
  mapped_code::text as  dbgap_submission_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//dbgap_submission'
  ), 
multiple_datasets_mappings as (
  select 
  source_text::text as  multiple_datasets,
  mapped_code::text as  multiple_datasets_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//multiple_datasets'
  ), 
proband_relationship_mappings as (
  select 
  source_text::text as  proband_relationship,
  mapped_code::text as  proband_relationship_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//proband_relationship'
  ), 
sex_mappings as (
  select 
  source_text::text as  sex,
  mapped_code::text as  sex_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//sex'
  ), 
phenotype_description_mappings as (
  select 
  source_text::text as  phenotype_description,
  mapped_code::text as  phenotype_description_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//phenotype_description'
  ), 
solve_state_mappings as (
  select 
  source_text::text as  solve_state,
  mapped_code::text as  solve_state_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//solve_state'
  )
  
  

select -- join the annotations
  base.*,
  affected_status_mapped_code,
  ancestry_mapped_code,
  congenital_status_mapped_code,
  dbgap_submission_mapped_code,
  multiple_datasets_mapped_code,
  proband_relationship_mapped_code,
  sex_mapped_code,
  phenotype_description_mapped_code,
  solve_state_mapped_code
from base
left join affected_status_mappings
using (affected_status)
left join ancestry_mappings
using (ancestry)
left join congenital_status_mappings
using (congenital_status)
left join dbgap_submission_mappings
using (dbgap_submission)
left join multiple_datasets_mappings
using (multiple_datasets)
left join proband_relationship_mappings
using (proband_relationship)
left join sex_mappings
using (sex)
left join phenotype_description_mappings
using (phenotype_description)
left join solve_state_mappings
using (solve_state)

