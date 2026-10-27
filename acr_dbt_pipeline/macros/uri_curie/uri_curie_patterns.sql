{% macro uri_curie_patterns() %}
    {%- set prefix = "[A-Za-z_][A-Za-z0-9_.-]*" -%}

    {{ return({
        'uri': '^([a-z][a-z0-9+.-]*://[^\\s/][^\\s]*|urn:[^\\s]+)$',
        'http_uri': '^https?://[^\\s/$.?#][^\\s]*$',
        'doi': '^10[.][0-9]{4,9}/[^\\s]+$',
        'curie': '^' ~ prefix ~ ':[^\\s/][^\\s]*$',
        'curie_prefix': '^' ~ prefix ~ '$'
    }) }}
{% endmacro %}
