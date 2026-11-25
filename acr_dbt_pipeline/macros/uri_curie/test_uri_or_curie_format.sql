{# Originally sourced from dbt_pipeline_utils (macros/uri_curie/uri_curie.sql). #}

{% test uri_or_curie_format(model, column_name) %}
    {%- set patterns = uri_curie_patterns() %}

select {{ column_name }} as value_to_check
from {{ model }}
where {{ column_name }} is not null
  and not {{ regex_match(column_name, patterns['uri']) }}
  and not {{ regex_match(column_name, patterns['curie']) }}

{% endtest %}
