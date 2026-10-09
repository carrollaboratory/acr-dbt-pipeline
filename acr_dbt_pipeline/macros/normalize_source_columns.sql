{% macro normalize_source_columns(relation, rename_map={}, null_sentinels=none) %}
  {% if not execute %}
    {{ return('*') }}
  {% endif %}

  {% if null_sentinels is none %}
    {% set null_sentinels = var('source_null_sentinels', ['na', 'n/a', 'null', 'none']) %}
  {% endif %}
  {% if null_sentinels | length == 0 %}
    {{ exceptions.raise_compiler_error('normalize_source_columns requires at least one null sentinel') }}
  {% endif %}

  {% set columns = adapter.get_columns_in_relation(relation) %}
  {% if columns | length == 0 %}
    {{ exceptions.raise_compiler_error('No columns found for source relation ' ~ relation) }}
  {% endif %}

  {% set normalized_names = [] %}
  {% for column in columns %}
    {% set source_name = column.name %}
    {% set default_name = source_name | lower %}
    {% set output_name = rename_map.get(default_name, default_name) | lower %}

    {% if output_name in normalized_names %}
      {{ exceptions.raise_compiler_error(
        "Duplicate normalized column '" ~ output_name ~ "' in " ~ relation
      ) }}
    {% endif %}
    {% do normalized_names.append(output_name) %}

    {% set quoted_source = adapter.quote(source_name) %}
    {% set text_value = 'trim(cast(' ~ quoted_source ~ ' as varchar))' %}
    case
      when {{ text_value }} = '' then cast(null as varchar)
      when lower({{ text_value }}) in (
        {%- for sentinel in null_sentinels -%}
          '{{ sentinel | lower | replace("'", "''") }}'{% if not loop.last %}, {% endif %}
        {%- endfor -%}
      ) then cast(null as varchar)
      else {{ text_value }}
    end as {{ adapter.quote(output_name) }}
    {%- if not loop.last %},{% endif %}
  {% endfor %}
{% endmacro %}
