{# Originally sourced from dbt_pipeline_utils (macros/uri_curie/uri_curie.sql). #}

{% test valid_http_uri(model, column_name) %}

select {{ column_name }} as value_to_check
from {{ model }}
where {{ column_name }} is not null
  and not {{ regex_match(column_name, uri_curie_patterns()['http_uri']) }}

{% endtest %}
