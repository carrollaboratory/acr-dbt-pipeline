{# Architecture-owned: enables only snapshots selected for this invocation. #}
{%- macro src_enabled(name, table_name='') -%}
  {%- set enabled = name in var('enabled_srcs', []) -%}
  {%- if enabled -%}
    {%- set cfg = tdr_snapshot_config(name) -%}
    {%- set site = cfg.get('site', '') | trim -%}
    {%- set consent = cfg.get('consent', '') | trim -%}
    {%- set site_filters = var('site_filters', []) -%}
    {%- set consent_filters = var('consent_filters', []) -%}
    {%- if site_filters | length > 0 -%}
      {%- set enabled = site in site_filters -%}
    {%- endif -%}
    {%- if enabled and consent_filters | length > 0 -%}
      {%- set enabled = consent in consent_filters -%}
    {%- endif -%}
  {%- endif -%}
  {%- if table_name -%}
    {%- set table_key = name ~ '.' ~ table_name -%}
    {%- set disabled_tables = var('disabled_src_tables', []) -%}
    {%- set enabled = enabled and table_key not in disabled_tables -%}
  {%- endif -%}
  {{- return(enabled) -}}
{%- endmacro -%}
