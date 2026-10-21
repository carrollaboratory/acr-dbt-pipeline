{# Architecture-owned: returns the configured local Parquet snapshots. #}
{%- macro tdr_parquet_sources() -%}
  {{- return(var('tdr_parquet_sources', {})) -}}
{%- endmacro -%}
