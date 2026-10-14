{#-
  Builds the src-layer select list for a Parquet source.

  Text columns are cleaned in a single DuckDB COLUMNS() expression, so the
  compiled SQL stays the same size no matter how many columns a table has.
  Applying a function to COLUMNS() keeps each column's original name, so no
  per-column alias is needed unless the name actually changes.

  Non-text columns are passed through untouched, so this layer never adds a
  varchar round-trip that could reformat a number. It preserves whatever the
  Parquet file already stores: a DECIMAL stays exact, but a DOUBLE is binary
  floating point and stays approximate. Precision or formatting already lost
  when the file was written cannot be recovered here.
-#}
{%- macro normalize_parquet_columns(path, rename_map={}) -%}
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
  {%- set text_cols = [] -%}
  {%- set typed_cols = [] -%}
  {%- set renamed_cols = [] -%}
  {%- for row in columns.rows -%}
    {%- set source_name = row[0] -%}
    {%- set is_text = (row[1] | upper) == 'VARCHAR' -%}
    {%- set output_name = rename_map.get(source_name | lower, source_name | lower) | lower -%}
    {%- if output_name in seen -%}
      {{- exceptions.raise_compiler_error(
        "Duplicate normalized column '" ~ output_name ~ "' in " ~ path
      ) -}}
    {%- endif -%}
    {%- do seen.append(output_name) -%}
    {%- if output_name != source_name -%}
      {%- do renamed_cols.append([source_name, output_name, is_text]) -%}
    {%- elif is_text -%}
      {%- do text_cols.append(source_name) -%}
    {%- else -%}
      {%- do typed_cols.append(source_name) -%}
    {%- endif -%}
  {%- endfor -%}
  {%- set parts = [] -%}
  {%- if text_cols | length > 0 -%}
    {%- do parts.append(
      text_cleaner_name() ~ '(COLUMNS(' ~ sql_name_list(text_cols) ~ '))'
    ) -%}
  {%- endif -%}
  {%- if typed_cols | length > 0 -%}
    {%- do parts.append('COLUMNS(' ~ sql_name_list(typed_cols) ~ ')') -%}
  {%- endif -%}
  {%- for col in renamed_cols -%}
    {%- set quoted_source = adapter.quote(col[0]) -%}
    {%- set quoted_output = adapter.quote(col[1]) -%}
    {%- if col[2] -%}
      {%- do parts.append(text_cleaner_name() ~ '(' ~ quoted_source ~ ') as ' ~ quoted_output) -%}
    {%- else -%}
      {%- do parts.append(quoted_source ~ ' as ' ~ quoted_output) -%}
    {%- endif -%}
  {%- endfor -%}
  {{- parts | join(',\n  ') -}}
{%- endmacro -%}
