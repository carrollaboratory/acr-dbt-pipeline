{# Architecture-owned: enables only snapshots selected for this invocation. #}
{%- macro src_enabled(name) -%}
  {{- return(name in var('enabled_srcs', [])) -}}
{%- endmacro -%}
