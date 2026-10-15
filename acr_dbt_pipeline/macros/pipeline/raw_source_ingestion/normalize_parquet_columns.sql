{#-
  Architecture-owned optional source-ingestion helper.

  Builds a src-layer select list straight from the Parquet schema, normalizing
  every column name to lower snake case and applying optional semantic overrides.

  This only normalizes NAMES. Value cleaning happens in the int stage, after
  cmg_main has unioned the snapshots, so it runs once per table instead of once
  per snapshot.

  Use it from a src model over a raw CTE. The CTE name is not introspectable by
  dbt, so this macro inspects the Parquet schema directly and qualifies each
  generated column with source_alias.

  rename_map uses the original column name (case-sensitive key preferred, then
  lowercase key) and may map it to a semantic name. The override is normalized
  to snake case too, for example {'Participant ID': 'subject_id'}.

  Values pass through untouched, so no varchar round-trip is introduced and the
  stored Parquet value and type are carried through unchanged.

  Column order is retained from the Parquet schema. Normalized-name collisions
  fail compilation rather than silently overwriting a column.
-#}
{%- macro normalize_parquet_columns(path, rename_map={}, source_alias='raw') -%}
  {%- if not execute -%}
    {{- return('*') -}}
  {%- endif -%}
  {%- set escaped_path = path | replace("'", "''") -%}
  {%- set columns_query -%}
    describe select * from read_parquet('{{ escaped_path }}')
  {%- endset -%}
  {%- set columns = run_query(columns_query) -%}
  {%- if columns is none or columns.rows | length == 0 -%}
    {{- exceptions.raise_compiler_error('No columns found for Parquet source ' ~ path) -}}
  {%- endif -%}
  {%- set seen = [] -%}
  {%- set select_cols = [] -%}
  {%- for row in columns.rows -%}
    {%- set source_name = row[0] -%}
    {%- set override_name = rename_map.get(source_name, rename_map.get(source_name | lower)) -%}
    {%- if override_name is none -%}
      {%- set output_name = snake_case_column_name(source_name) -%}
    {%- else -%}
      {%- set output_name = snake_case_column_name(override_name) -%}
    {%- endif -%}
    {%- if output_name in seen -%}
      {{- exceptions.raise_compiler_error(
        "Duplicate normalized column '" ~ output_name ~ "' in " ~ path
      ) -}}
    {%- endif -%}
    {%- do seen.append(output_name) -%}
    {%- do select_cols.append(
      adapter.quote(source_alias) ~ '.' ~ adapter.quote(source_name)
      ~ ' as ' ~ adapter.quote(output_name)
    ) -%}
  {%- endfor -%}
  {{- select_cols | join(',\n  ') -}}
{%- endmacro -%}
