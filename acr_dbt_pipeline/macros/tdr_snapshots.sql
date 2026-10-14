{#
  Helpers for Parquet-backed TDR snapshots.

  The source configuration lives in dbt_project.yml vars rather than
  environment variables or BigQuery catalog attachments.
#}

{% macro tdr_parquet_sources() %}
  {{ return(var('tdr_parquet_sources', {})) }}
{% endmacro %}


{% macro tdr_snapshot_config(name) %}
  {% set snapshots = tdr_parquet_sources() %}
  {% if name not in snapshots %}
    {{ exceptions.raise_compiler_error(
      "Unknown Parquet snapshot '" ~ name ~ "'. Declare it under"
      ~ " vars.tdr_parquet_sources in dbt_project.yml. Known snapshots: "
      ~ (snapshots.keys() | list | join(', '))
    ) }}
  {% endif %}
  {{ return(snapshots[name]) }}
{% endmacro %}


{% macro tdr_parquet_root() %}
  {% set root = var('tdr_parquet_root', '') | trim %}
  {% if not root %}
    {{ exceptions.raise_compiler_error('vars.tdr_parquet_root must be a local directory') }}
  {% endif %}
  {% if '://' in root %}
    {{ exceptions.raise_compiler_error('vars.tdr_parquet_root must be local, not a URL: ' ~ root) }}
  {% endif %}
  {{ return(root.rstrip('/')) }}
{% endmacro %}


{% macro tdr_snapshot_path(name, table_name) %}
  {% set snapshot = tdr_snapshot_config(name) %}
  {% set path = snapshot.get('path', '') | trim %}
  {% if not path %}
    {{ exceptions.raise_compiler_error(
      "Parquet path is empty for snapshot '" ~ name ~ "'"
    ) }}
  {% endif %}
  {% if '{table}' not in path %}
    {{ exceptions.raise_compiler_error(
      "Parquet path for snapshot '" ~ name ~ "' must contain the {table} placeholder"
    ) }}
  {% endif %}
  {% if not table_name %}
    {{ exceptions.raise_compiler_error(
      "A table name is required for Parquet snapshot '" ~ name ~ "'"
    ) }}
  {% endif %}
  {% if '://' in path %}
    {{ exceptions.raise_compiler_error(
      "Parquet path for snapshot '" ~ name ~ "' must be local, not a URL: " ~ path
    ) }}
  {% endif %}
  {% set path = tdr_parquet_root() ~ '/' ~ path.lstrip('/') %}
  {% set path = path | replace('{table}', table_name) %}
  {{ return(path) }}
{% endmacro %}


{% macro tdr_snapshot_id(name) %}
  {% set snapshot = tdr_snapshot_config(name) %}
  {{ return(snapshot.get('snapshot_id', '')) }}
{% endmacro %}
