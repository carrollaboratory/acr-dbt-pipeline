{# Architecture-owned: resolves a snapshot/table pair to a local Parquet glob. #}
{%- macro tdr_snapshot_path(name, table_name) -%}
  {%- set snapshot = tdr_snapshot_config(name) -%}
  {%- set path = snapshot.get('path', '') | trim -%}
  {%- if not path -%}
    {{- exceptions.raise_compiler_error(
      "Parquet path is empty for snapshot '" ~ name ~ "'"
    ) -}}
  {%- endif -%}
  {%- if '{table}' not in path -%}
    {{- exceptions.raise_compiler_error(
      "Parquet path for snapshot '" ~ name ~ "' must contain the {table} placeholder"
    ) -}}
  {%- endif -%}
  {%- if not table_name -%}
    {{- exceptions.raise_compiler_error(
      "A table name is required for Parquet snapshot '" ~ name ~ "'"
    ) -}}
  {%- endif -%}
  {%- if '://' in path -%}
    {{- exceptions.raise_compiler_error(
      "Parquet path for snapshot '" ~ name ~ "' must be local, not a URL: " ~ path
    ) -}}
  {%- endif -%}
  {%- set path = tdr_parquet_root() ~ '/' ~ path.lstrip('/') -%}
  {{- return(path | replace('{table}', table_name)) -}}
{%- endmacro -%}
