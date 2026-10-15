{# Architecture-owned: returns provenance for one configured snapshot. #}
{%- macro tdr_snapshot_id(name) -%}
  {{- return(tdr_snapshot_config(name).get('snapshot_id', '')) -}}
{%- endmacro -%}
