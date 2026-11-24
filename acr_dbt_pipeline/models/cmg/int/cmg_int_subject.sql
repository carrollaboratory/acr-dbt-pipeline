{%- set mapping_fields = [
  'affected_status', 'ancestry', 'congenital_status', 'dbgap_submission',
  'multiple_datasets', 'proband_relationship', 'sex', 'phenotype_description',
  'solve_state'
] -%}
{%- set metadata_columns = [
  'concept_curie', 'concept_display', 'concept_definition', 'vocabulary_prefix',
  'fhir_system', 'concept_uri_or_curie'
] -%}

with base as ( -- join the base table to anvil_dataset
  select 
    {{ dbt_utils.star(ref('cmg_main_subject'), relation_alias='s') }},
    {{ dbt_utils.star(ref('cmg_int_anvil_dataset'), relation_alias='ad', except=['source_snapshot_id', 'source_snapshot', 'dataset_gid', 'dataset_id_descriptor', 'dataset_id', 'dataset_title', 'data_use_permission_duo_code', 'data_use_modifier_duo_codes', 'disease_limitation']) }},
    {{ generate_md5_global_id(prefix='sb', descriptor=['subject_id','consent_group']) }}::text as subject_gid,
    {{ generate_descriptor_for_analysis(prefix='sb', descriptor=['subject_id','consent_group']) }}::text as subject_id_descriptor,
    {{ generate_md5_global_id(prefix='pr', descriptor=['subject_id','consent_group']) }}::text as person_gid,
    {{ generate_descriptor_for_analysis(prefix='pr', descriptor=['subject_id','consent_group']) }}::text as person_id_descriptor,
    {{ model_enum_concept('Subject', 'subject_type', 'Participant') }}::text as subject_type_source,
    {{ hardcoded_concept('organism_type') }}::text as organism_type_source
  from {{ ref("cmg_main_subject")}} s
  left join {{ ref("cmg_int_anvil_dataset")}} ad
  using(source_snapshot_id)
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
  subject_type.concept_curie as subject_type_concept_curie,
  organism_type.concept_curie as organism_type_concept_curie,
  organism_type.concept_uri_or_curie as organism_type_concept_uri_or_curie,
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
left join {{ ref('cmg_int_concept_metadata') }} as subject_type
  on subject_type.source_concept = base.subject_type_source
left join {{ ref('cmg_int_concept_metadata') }} as organism_type
  on organism_type.source_concept = base.organism_type_source
