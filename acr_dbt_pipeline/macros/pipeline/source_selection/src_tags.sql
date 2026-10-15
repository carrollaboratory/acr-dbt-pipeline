{# Architecture-owned: derives stable site and consent tags from configuration. #}
{%- macro src_tags(name) -%}
  {%- set cfg = tdr_snapshot_config(name) -%}
  {%- set site = cfg.get('site', '') | trim -%}
  {%- set consent = cfg.get('consent', '') | trim -%}
  {%- if not site or not consent -%}
    {{- exceptions.raise_compiler_error(
      "Snapshot '" ~ name ~ "' needs both 'site' and 'consent' under"
      ~ " vars.tdr_parquet_sources in dbt_project.yml"
    ) -}}
  {%- endif -%}
  {{- return([name, site, consent]) -}}
{%- endmacro -%}
