{%- macro src_model_key(name) -%}
  {%- set cfg = tdr_snapshot_config(name) -%}
  {%- set prefix = cfg.get('site') ~ '_' -%}
  {%- if not name.startswith(prefix) -%}
    {{- exceptions.raise_compiler_error(
      "Snapshot '" ~ name ~ "' must start with its configured site and an underscore: "
      ~ prefix
    ) -}}
  {%- endif -%}
  {{- return(name[prefix | length:]) -}}
{%- endmacro -%}
