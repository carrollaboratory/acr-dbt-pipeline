{%- set sample_cols = [
  'sample_gid', 'sample_id_descriptor',
  'subject_id', 'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor',
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group', 'sequencing_center'
] -%}
{%- set mapping_fields = [
  'analyte_type', 'sequencing_assay', 'functional_equivalence_standard'
] -%}
{%- set metadata_columns = [
  'concept_curie', 'concept_display', 'concept_definition', 'vocabulary_prefix',
  'fhir_system', 'concept_uri_or_curie'
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
{% for field in mapping_fields %}
{{ field }}_mappings as (
  select
    source_text::text as {{ field }},
    mapped_code::text as {{ field }}_mapped_code,
    {% for column in metadata_columns %}
    {{ column }} as {{ field }}_{{ column }}{{ ',' if not loop.last }}
    {% endfor %}
  from {{ ref('cmg_int_mapdragon_annotations') }}
  where source_system = 'https://anvilproject.org//{{ field }}'
){{ ',' if not loop.last }}
{% endfor %}
  
select -- join the annotations
  base.*,
  {% for field in mapping_fields %}
  {{ field }}_mapped_code,
  {% for column in metadata_columns %}
  {{ field }}_{{ column }},
  {% endfor %}
  {% endfor %}
from base
{% for field in mapping_fields %}
left join {{ field }}_mappings
using ({{ field }})
{% endfor %}
