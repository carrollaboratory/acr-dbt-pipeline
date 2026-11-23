{# Originally sourced from dbt_pipeline_utils (macros/uri_curie/normalize_doi.sql). #}

{% macro normalize_doi(column_name) %}
    nullif(trim(cast({{ column_name }} as {{ dbt.type_string() }})), '')
{% endmacro %}
