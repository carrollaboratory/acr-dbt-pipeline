{%- set sample_cols = [
  'sample_gid', 'sample_id_descriptor',
  'subject_id', 'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor',
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group', 'sequencing_center'
] -%}

with base as (
select
  {{ dbt_utils.star(ref('cmg_main_sequencing'), relation_alias='seq', except=sample_cols) }},
  {% for col in sample_cols -%}
  sa."{{ col }}",
  {% endfor -%}
  {{ generate_md5_global_id(prefix='ay', descriptor=['seq.sequencing_id','sa.consent_group']) }}::text as assay_gid,
  {{ generate_descriptor_for_analysis(prefix='ay', descriptor=['seq.sequencing_id','sa.consent_group']) }}::text as assay_id_descriptor
from {{ ref('cmg_main_sequencing') }} seq
left join (
select distinct
  sample_id,
  source_snapshot_id,
  {{ sample_cols | join(',\n  ') }}
from {{ ref("cmg_int_sample") }} ) sa
using (sample_id, source_snapshot_id)
),
analyte_type_mappings as (
  select 
  source_text::text as analyte_type,
  mapped_code::text as analyte_type_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//analyte_type' -- none as of 11/2026
),
sequencing_assay_mappings as (
  select 
  source_text::text as sequencing_assay,
  mapped_code::text as sequencing_assay_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//sequencing_assay' -- none as of 11/2026
),
functional_equivalence_standard_mappings as (
  select 
  source_text::text as functional_equivalence_standard,
  mapped_code::text as functional_equivalence_standard_mapped_code
  from {{ ref("mapdragon_annotations_talon") }}
  where source_system = 'https://anvilproject.org//functional_equivalence_standard' -- none as of 11/2026
  )
  
select -- join the annotations
  base.*
from base
left join analyte_type_mappings
using (analyte_type)
left join sequencing_assay_mappings
using (sequencing_assay)
left join functional_equivalence_standard_mappings
using (functional_equivalence_standard)
