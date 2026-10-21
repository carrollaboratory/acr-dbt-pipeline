{# Architecture-owned: enables only snapshots selected for this invocation. #}
{%- macro src_enabled(name, table_name='') -%}
  {%- set enabled = name in var('enabled_srcs', []) -%}
  {%- if table_name -%}
    {%- set table_key = name ~ '.' ~ table_name -%}
    {%- set disabled_tables = var('disabled_src_tables', []) -%}
    {%- set enabled = enabled and table_key not in disabled_tables -%}
  {%- endif -%}
  {{- return(enabled) -}}
{%- endmacro -%}
