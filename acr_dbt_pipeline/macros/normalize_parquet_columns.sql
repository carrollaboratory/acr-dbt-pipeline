{% macro normalize_parquet_columns(path, alias='raw', rename_map={}, null_sentinels=none) %}
  {% if not execute %}
    {{ return('*') }}
  {% endif %}

  {% if null_sentinels is none %}
    {% set null_sentinels = var('source_null_sentinels', ['na', 'n/a', 'null', 'none']) %}
  {% endif %}
  {% if null_sentinels | length == 0 %}
    {{ exceptions.raise_compiler_error('normalize_parquet_columns requires at least one null sentinel') }}
  {% endif %}

  {% set escaped_path = path | replace("'", "''") %}
  {% set columns_query %}
    describe select * from read_parquet('{{ escaped_path }}')
  {% endset %}
  {% set columns = run_query(columns_query) %}
  {% if columns is none or columns.rows | length == 0 %}
    {{ exceptions.raise_compiler_error('No columns found for Parquet source ' ~ path) }}
  {% endif %}

  {% set normalized_names = [] %}
  {% for row in columns.rows %}
    {% set source_name = row[0] %}
    {% set default_name = source_name | lower %}
    {% set output_name = rename_map.get(default_name, default_name) | lower %}

    {% if output_name in normalized_names %}
      {{ exceptions.raise_compiler_error(
        "Duplicate normalized column '" ~ output_name ~ "' in " ~ path
      ) }}
    {% endif %}
    {% do normalized_names.append(output_name) %}

    {% set quoted_source = adapter.quote(source_name) %}
    {% set text_value = alias ~ '.' ~ quoted_source ~ '::varchar' %}
    case
      when trim({{ text_value }}) = '' then cast(null as varchar)
      when lower(trim({{ text_value }})) in (
        {%- for sentinel in null_sentinels -%}
          '{{ sentinel | lower | replace("'", "''") }}'{% if not loop.last %}, {% endif %}
        {%- endfor -%}
      ) then cast(null as varchar)
      else trim({{ text_value }})
    end as {{ adapter.quote(output_name) }}
    {%- if not loop.last %},{% endif %}
  {% endfor %}
{% endmacro %}
