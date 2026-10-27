{% macro normalize_http_uri(column_name, default_scheme='https') %}
    {%- set value = "nullif(trim(cast(" ~ column_name ~ " as " ~ dbt.type_string() ~ ")), '')" -%}
    case
        when {{ value }} is null then null
        when lower({{ value }}) like 'http://%' or lower({{ value }}) like 'https://%'
            then lower(split_part({{ value }}, ':', 1)) || substr({{ value }}, strpos({{ value }}, ':'))
        when {{ regex_match(value, '^([A-Za-z0-9-]+[.])+[A-Za-z]{2,}([/?#][^\\s]*)?$') }}
            then '{{ default_scheme }}://' || {{ value }}
        else {{ value }}
    end
{% endmacro %}
