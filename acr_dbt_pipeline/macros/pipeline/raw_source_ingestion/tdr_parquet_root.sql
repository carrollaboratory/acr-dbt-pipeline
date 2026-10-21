{# Architecture-owned: validates the local root containing Parquet exports. #}
{%- macro tdr_parquet_root(root_override='') -%}
  {%- set root = root_override | trim -%}
  {%- if not root -%}
    {%- set root = var('tdr_parquet_root', '') | trim -%}
  {%- endif -%}
  {%- if root == '~' or root.startswith('~/') -%}
    {%- set root = env_var('HOME') ~ root[1:] -%}
  {%- endif -%}
  {%- if not root -%}
    {{- exceptions.raise_compiler_error('vars.tdr_parquet_root must be a local directory') -}}
  {%- endif -%}
  {%- if '://' in root -%}
    {{- exceptions.raise_compiler_error('vars.tdr_parquet_root must be local, not a URL: ' ~ root) -}}
  {%- endif -%}
  {{- return(root.rstrip('/')) -}}
{%- endmacro -%}
