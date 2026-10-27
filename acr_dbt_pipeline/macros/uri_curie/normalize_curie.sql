{% macro normalize_curie(column_name, default_prefix=none, local_id_pattern=none, prefix_seed='curie_prefixes', prefix_column='prefix', alias_column='alias_prefix') %}
    {#- Accepts phs123456 and phs123456.v1.p1. -#}
    {%- set dbgap_pattern = '^phs[0-9]{6}([.]v[0-9]+[.]p[0-9]+)?$' -%}
    {%- set builtin_patterns = {
        'dbgap': dbgap_pattern
    } -%}
    {%- if default_prefix and not local_id_pattern -%}
        {%- set local_id_pattern = builtin_patterns.get(default_prefix | lower) -%}
    {%- endif -%}
    {%- if default_prefix and not local_id_pattern -%}
        {{ exceptions.raise_compiler_error("normalize_curie: unknown default_prefix '" ~ default_prefix ~ "'; provide local_id_pattern for custom prefixes.") }}
    {%- endif -%}
    {%- set value = "nullif(trim(cast(" ~ column_name ~ " as " ~ dbt.type_string() ~ ")), '')" -%}
    {%- set has_prefix = value ~ " like '%:%'" -%}
    {%- if default_prefix -%}
        {%- set src_prefix = "case when " ~ has_prefix ~ " then trim(split_part(" ~ value ~ ", ':', 1)) else '" ~ default_prefix ~ "' end" -%}
        {%- set local_id = "case when " ~ has_prefix ~ " then trim(substr(" ~ value ~ ", strpos(" ~ value ~ ", ':') + 1)) else " ~ value ~ " end" -%}
    {%- else -%}
        {%- set src_prefix = "trim(split_part(" ~ value ~ ", ':', 1))" -%}
        {%- set local_id = "trim(substr(" ~ value ~ ", strpos(" ~ value ~ ", ':') + 1))" -%}
    {%- endif -%}
    case
        when {{ value }} is null then null
        when {{ value }} like '%://%' or lower({{ value }}) like 'urn:%' then {{ value }}
        {%- if default_prefix %}
        when not ({{ has_prefix }}) and not {{ regex_match(value, local_id_pattern) }} then {{ value }}
        {%- else %}
        when not ({{ has_prefix }}) then {{ value }}
        {%- endif %}
        else coalesce(
            (
                select max(p.{{ prefix_column }})
                from {{ ref(prefix_seed) }} as p
                where lower(p.{{ prefix_column }}) = lower({{ src_prefix }})
                   or lower(p.{{ alias_column }}) = lower({{ src_prefix }})
            ),
            {{ src_prefix }}
        ) || ':' || {{ local_id }}
    end
{% endmacro %}
