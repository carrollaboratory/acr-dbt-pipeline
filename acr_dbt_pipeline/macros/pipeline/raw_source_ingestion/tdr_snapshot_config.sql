{# Architecture-owned: validates and returns one snapshot configuration. #}
{%- macro tdr_snapshot_config(name) -%}
  {%- set snapshots = tdr_parquet_sources() -%}
  {%- if name not in snapshots -%}
    {{- exceptions.raise_compiler_error(
      "Unknown Parquet snapshot '" ~ name ~ "'. Declare it under"
      ~ " vars.tdr_parquet_sources in dbt_project.yml. Known snapshots: "
      ~ (snapshots.keys() | list | join(', '))
    ) -}}
  {%- endif -%}
  {{- return(snapshots[name]) -}}
{%- endmacro -%}
