{% macro model_enum_concept(table_name, variable_name, enumeration_title) %}
    coalesce(
        (
            select distinct nullif(enumeration_code, '')
            from {{ ref('model_enums') }}
            where table_name = '{{ table_name | replace("'", "''") }}'
              and variable_name = '{{ variable_name | replace("'", "''") }}'
              and enumeration_title = '{{ enumeration_title | replace("'", "''") }}'
        ),
        error('model_enums has no code for {{ table_name | replace("'", "''") }}.{{ variable_name | replace("'", "''") }}: {{ enumeration_title | replace("'", "''") }}')
    )
{% endmacro %}

{% macro hardcoded_concept(model_variable) %}
    coalesce(
        (
            select nullif(concept_curie, '')
            from {{ ref('hardcoded_concepts') }}
            where model_variable = '{{ model_variable | replace("'", "''") }}'
        ),
        error('hardcoded_concepts has no CURIE for model_variable {{ model_variable | replace("'", "''") }}')
    )
{% endmacro %}
