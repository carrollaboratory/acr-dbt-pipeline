{# Architecture-owned: validates the local root containing Parquet exports. #}
{%- macro tdr_parquet_root() -%}
  {%- set root = var('tdr_parquet_root', '') | trim -%}
  {%- if not root -%}
    {{- exceptions.raise_compiler_error('vars.tdr_parquet_root must be a local directory') -}}
  {%- endif -%}
  {%- if '://' in root -%}
    {{- exceptions.raise_compiler_error('vars.tdr_parquet_root must be local, not a URL: ' ~ root) -}}
  {%- endif -%}
  {{- return(root.rstrip('/')) -}}
{%- endmacro -%}
