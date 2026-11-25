{%- set mapping_fields = ['consanguinity', 'family_history'] -%}
{#- NULL source values are looked up as this text in the mapping annotations. -#}
{%- set null_as = {'consanguinity': 'Unknown'} -%}
{%- set metadata_columns = [
  'concept_curie', 'concept_display', 'concept_definition', 'vocabulary_prefix',
  'fhir_system', 'concept_uri_or_curie'
] -%}

with base as (
select
  {{ dbt_utils.star(ref('cmg_main_family'), relation_alias='f') }},
  {{ dbt_utils.star(ref('cmg_int_anvil_dataset'), relation_alias='ad', except=['source_snapshot_id', 'source_snapshot', 'dataset_gid', 'dataset_id_descriptor', 'dataset_id', 'dataset_title', 'data_use_permission_duo_code', 'data_use_modifier_duo_codes', 'disease_limitation']) }},
  {{ generate_md5_global_id(prefix='fy', descriptor=["family_id"]) }}::text  as family_gid,
  {{ generate_descriptor_for_analysis(prefix='fy', descriptor=["family_id"]) }}::text as family_id_descriptor
from {{ ref('cmg_main_family') }} f
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
    {% for field in mapping_fields %}
    {{ field }}_mapped_code,
    {% for column in metadata_columns %}
    {{ field }}_{{ column }},
    {% endfor %}
    {% endfor %}
  from base
  {% for field in mapping_fields %}
  left join {{ field }}_mappings
  {%- if field in null_as %}
  on {{ field }}_mappings.{{ field }} = coalesce(base.{{ field }}, '{{ null_as[field] }}')
  {%- else %}
  using ({{ field }})
  {%- endif %}
  {% endfor %}
