{#-
  Originally sourced from dbt_pipeline_utils (dbt-pipeline-utils repo:
  macros/warehouse_naming/schema_name_from_path.sql), inlined here as ACR's
  dbt schema naming override. Copied locally, not imported; keep in sync by hand.

  - explicit +schema config wins: <target.schema>_<custom_schema_name>
  - seeds: <target.schema>
  - models/<a>/x.sql: <target.schema>_<a>
  - models/<a>/<b>/.../<layer>/x.sql: <target.schema>_<a>_<b>... (last folder dropped)
    e.g. models/cmg/int/x.sql -> main_cmg
-#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema | trim -%}
    {%- if custom_schema_name is not none and custom_schema_name | trim != '' -%}
        {{ return(default_schema ~ '_' ~ (custom_schema_name | trim)) }}
    {%- endif -%}
    {%- if node.resource_type == 'seed' -%}
        {{ return(default_schema) }}
    {%- endif -%}

    {%- set folders = node.fqn[1:-1] -%}
    {%- if folders | length == 0 -%}
        {{ return(default_schema) }}
    {%- endif -%}
    {%- set parts = folders if folders | length == 1 else folders[:-1] -%}
    {{ return(default_schema ~ '_' ~ (parts | join('_'))) }}
{%- endmacro %}
