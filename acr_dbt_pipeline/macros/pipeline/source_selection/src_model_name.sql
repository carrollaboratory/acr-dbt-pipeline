{# Architecture-owned: maps snapshot configuration to the src model convention. #}
{%- macro src_model_name(name, table_name) -%}
  {%- set cfg = tdr_snapshot_config(name) -%}
  {%- do src_tags(name) -%}
  {{- return(cfg.get('site') ~ '_src_' ~ src_model_key(name) ~ '_' ~ table_name) -}}
{%- endmacro -%}
