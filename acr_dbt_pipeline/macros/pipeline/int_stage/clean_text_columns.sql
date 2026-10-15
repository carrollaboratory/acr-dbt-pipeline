{#-
  Architecture-owned int-stage cleaning.

  Builds a select list that cleans every text column of an upstream relation.

  Text columns are cleaned in a single DuckDB COLUMNS() expression, so the
  compiled SQL stays the same size no matter how many columns the table has.
  Applying a function to COLUMNS() keeps each column's original name, so no
  per-column alias is needed.

  Non-text columns pass through untouched, so this layer never adds a varchar
  round-trip that could reformat a number. That preserves whatever the upstream
  already stores: a DECIMAL stays exact, but a DOUBLE is binary floating point
  and stays approximate.

  Columns are emitted text-first, so the output column order may differ from
  the input order.

  This introspects the upstream table, so it needs that table to already exist.
  Use `dbt run` (which builds in DAG order) rather than `dbt compile` against a
  database where the upstream model has never been built.
-#}
{%- macro clean_text_columns(relation, exclude=[]) -%}
  {%- if not execute -%}
    {{- return('*') -}}
  {%- endif -%}
  {%- set columns = adapter.get_columns_in_relation(relation) -%}
  {%- if columns | length == 0 -%}
    {{- exceptions.raise_compiler_error(
      'No columns found for ' ~ relation ~ '. Build the upstream model first,'
      ~ ' for example with `dbt run --select +' ~ this.name ~ '`.'
    ) -}}
  {%- endif -%}
  {%- set excluded = [] -%}
  {%- for name in exclude -%}
    {%- do excluded.append(name | lower) -%}
  {%- endfor -%}
  {%- set text_cols = [] -%}
  {%- set other_cols = [] -%}
  {%- for column in columns -%}
    {%- if column.is_string() and column.name | lower not in excluded -%}
      {%- do text_cols.append(column.name) -%}
    {%- else -%}
      {%- do other_cols.append(column.name) -%}
    {%- endif -%}
  {%- endfor -%}
  {%- set parts = [] -%}
  {%- if text_cols | length > 0 -%}
    {%- do parts.append(
      text_cleaner_name() ~ '(COLUMNS(' ~ sql_name_list(text_cols) ~ '))'
    ) -%}
  {%- endif -%}
  {%- if other_cols | length > 0 -%}
    {%- do parts.append('COLUMNS(' ~ sql_name_list(other_cols) ~ ')') -%}
  {%- endif -%}
  {{- parts | join(',\n  ') -}}
{%- endmacro -%}
