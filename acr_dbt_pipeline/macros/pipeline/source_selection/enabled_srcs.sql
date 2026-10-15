{# Architecture-owned: validates and returns the selected snapshot list. #}
{%- macro enabled_srcs() -%}
  {%- set names = var('enabled_srcs', []) -%}
  {%- if names | length == 0 -%}
    {{- exceptions.raise_compiler_error(
      'vars.enabled_srcs is empty, so there is nothing to union'
    ) -}}
  {%- endif -%}
  {%- for name in names -%}
    {%- do tdr_snapshot_config(name) -%}
  {%- endfor -%}
  {{- return(names) -}}
{%- endmacro -%}
