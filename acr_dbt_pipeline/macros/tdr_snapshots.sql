{#
  Helpers for toggling TDR snapshots on and off.

  Access to a TDR snapshot depends on DUOS approvals and on whether the
  snapshot has been published at all, so the project has to parse and run
  when only a subset of the declared snapshots is usable. Each snapshot has
  an independent TDR_<NAME>_ENABLED environment variable.
#}

{% macro tdr_enabled_snapshots() %}
  {% set enabled = [] %}
  {% for name in var('tdr_snapshots', {}).keys() %}
    {% if tdr_snapshot_enabled(name) %}
      {% do enabled.append(name) %}
    {% endif %}
  {% endfor %}

  {{ return(enabled) }}
{% endmacro %}


{% macro tdr_snapshot_enabled(name) %}
  {% set variable = 'TDR_' ~ (name | upper) ~ '_ENABLED' %}
  {% set default = 'true' if name | lower == 'cmg_yale_gru' else 'false' %}
  {% set value = env_var(variable, default) | trim | lower %}

  {% if value not in ['true', 'false'] %}
    {{ exceptions.raise_compiler_error(
      variable ~ " must be either 'true' or 'false', got '" ~ value ~ "'"
    ) }}
  {% endif %}

  {{ return(value == 'true') }}
{% endmacro %}


{% macro tdr_snapshot_config(name) %}
  {% set snapshots = var('tdr_snapshots', {}) %}
  {% if name not in snapshots %}
    {{ exceptions.raise_compiler_error(
      "Unknown TDR snapshot '" ~ name ~ "'. Declare it under vars.tdr_snapshots"
      ~ " in dbt_project.yml. Known snapshots: " ~ (snapshots.keys() | list | join(', '))
    ) }}
  {% endif %}
  {{ return(snapshots[name]) }}
{% endmacro %}


{#
  Returns the snapshot UUID for provenance columns. Defaults to an empty
  string so that a disabled snapshot never fails to render.
#}
{% macro tdr_snapshot_id(name) %}
  {% set snapshot = tdr_snapshot_config(name) %}
  {{ return(env_var(snapshot['snapshot_id_env_var'], '')) }}
{% endmacro %}


{#
  Run as an on-run-start hook. Turns the confusing DuckDB "Catalog with name
  x does not exist" / "Table does not exist" errors into an actionable
  message naming exactly which variable or attach block is missing.
#}
{% macro assert_enabled_snapshots_configured() %}
  {% if not execute %}
    {{ return('select 1 as skipped_during_parse') }}
  {% endif %}

  {% set snapshots = var('tdr_snapshots', {}) %}
  {% set problems = [] %}

  {% set attached = [] %}
  {% set attached_rows = run_query('select database_name from duckdb_databases()') %}
  {% if attached_rows is not none %}
    {% for row in attached_rows.rows %}
      {% do attached.append(row[0]) %}
    {% endfor %}
  {% endif %}

  {% for name in tdr_enabled_snapshots() %}
    {% if name not in snapshots %}
      {% do problems.append(
        name ~ " is listed in enabled_snapshots but is not declared under"
        ~ " vars.tdr_snapshots in dbt_project.yml"
      ) %}
    {% else %}
      {% set snapshot = snapshots[name] %}
      {% for key in ['project_env_var', 'dataset_env_var', 'snapshot_id_env_var'] %}
        {% if env_var(snapshot[key], '') == '' %}
          {% do problems.append(
            name ~ ": " ~ snapshot[key] ~ " is empty or unset. Generate it with"
            ~ " scripts/fetch_tdr_snapshot_env.sh and add it to the workspace .env"
          ) %}
        {% endif %}
      {% endfor %}
      {% if snapshot['catalog'] not in attached %}
        {% do problems.append(
          name ~ ": BigQuery catalog '" ~ snapshot['catalog'] ~ "' is not attached."
          ~ " Uncomment its attach block in profiles.yml"
        ) %}
      {% endif %}
    {% endif %}
  {% endfor %}

  {% if problems | length > 0 %}
    {{ exceptions.raise_compiler_error(
      "Enabled TDR snapshots are not fully configured:\n  - "
      ~ (problems | join("\n  - "))
    ) }}
  {% endif %}

  {{ return('select 1 as enabled_snapshots_ok') }}
{% endmacro %}
