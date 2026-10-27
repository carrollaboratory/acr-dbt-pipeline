{% macro regex_match(expression, pattern) %}
    {{ return(adapter.dispatch('regex_match')(expression, pattern)) }}
{% endmacro %}

{% macro default__regex_match(expression, pattern) %}
    (cast({{ expression }} as {{ dbt.type_string() }}) ~ '{{ pattern | replace("'", "''") }}')
{% endmacro %}

{% macro duckdb__regex_match(expression, pattern) %}
    regexp_matches(cast({{ expression }} as {{ dbt.type_string() }}), '{{ pattern | replace("'", "''") }}')
{% endmacro %}
