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
    mapped_code::text as analyte_type_mapped_code,
    concept_curie as analyte_type_concept_curie,
    concept_display as analyte_type_concept_display,
    concept_definition as analyte_type_concept_definition,
    vocabulary_prefix as analyte_type_vocabulary_prefix,
    fhir_system as analyte_type_fhir_system,
    concept_uri_or_curie as analyte_type_concept_uri_or_curie
  from {{ ref('cmg_int_mapdragon_annotations') }}
  where source_system in (
    'https://anvilproject.org//seq.sequencing_id','https://anvilproject.org//seq.sequencing_id'
  )
),

sequencing_assay_mappings as (
  select
    source_text::text as sequencing_assay,
    mapped_code::text as sequencing_assay_mapped_code,
    concept_curie as sequencing_assay_concept_curie,
    concept_display as sequencing_assay_concept_display,
    concept_definition as sequencing_assay_concept_definition,
    vocabulary_prefix as sequencing_assay_vocabulary_prefix,
    fhir_system as sequencing_assay_fhir_system,
    concept_uri_or_curie as sequencing_assay_concept_uri_or_curie
  from {{ ref('cmg_int_mapdragon_annotations') }}
  where source_system in (
    'https://anvilproject.org//sequencing_id','https://anvilproject.org//sequencing_id'
  )
),

functional_equivalence_standard_mappings as (
  select
    source_text::text as functional_equivalence_standard,
    mapped_code::text as functional_equivalence_standard_mapped_code,
    concept_curie as functional_equivalence_standard_concept_curie,
    concept_display as functional_equivalence_standard_concept_display,
    concept_definition as functional_equivalence_standard_concept_definition,
    vocabulary_prefix as functional_equivalence_standard_vocabulary_prefix,
    fhir_system as functional_equivalence_standard_fhir_system,
    concept_uri_or_curie as functional_equivalence_standard_concept_uri_or_curie
  from {{ ref('cmg_int_mapdragon_annotations') }}
  where source_system in (
    'https://anvilproject.org//seq.sequencing_id','https://anvilproject.org//seq.sequencing_id'
  )
)

select -- join the annotations
  base.*,
  analyte_type_mapped_code,
  analyte_type_concept_curie,
  analyte_type_concept_display,
  analyte_type_concept_definition,
  analyte_type_vocabulary_prefix,
  analyte_type_fhir_system,
  analyte_type_concept_uri_or_curie,
  sequencing_assay_mapped_code,
  sequencing_assay_concept_curie,
  sequencing_assay_concept_display,
  sequencing_assay_concept_definition,
  sequencing_assay_vocabulary_prefix,
  sequencing_assay_fhir_system,
  sequencing_assay_concept_uri_or_curie,
  functional_equivalence_standard_mapped_code,
  functional_equivalence_standard_concept_curie,
  functional_equivalence_standard_concept_display,
  functional_equivalence_standard_concept_definition,
  functional_equivalence_standard_vocabulary_prefix,
  functional_equivalence_standard_fhir_system,
  functional_equivalence_standard_concept_uri_or_curie
from base
left join analyte_type_mappings
  using (analyte_type)
left join sequencing_assay_mappings
  on sequencing_assay_mappings.sequencing_assay = coalesce(base.sequencing_assay, 'NA NULL') -- NULL source values are annotated as 'NA NULL'
left join functional_equivalence_standard_mappings
  using (functional_equivalence_standard)
