{#-
  Architecture-owned: installs the shared DuckDB text cleaner.

  Defining this once keeps compiled models compact. dbt_project.yml invokes it
  through on-run-start; models should call clean_text_columns(), not duplicate
  or replace this rule.
-#}
{%- macro create_text_cleaner(null_sentinels=none) -%}
  {%- if null_sentinels is none -%}
    {%- set null_sentinels = var('source_null_sentinels', ['na', 'n/a', 'null', 'none']) -%}
  {%- endif -%}
  {%- set literals = ["''"] -%}
  {%- for sentinel in null_sentinels -%}
    {%- set cleaned = sentinel | lower | trim -%}
    {%- if cleaned != '' -%}
      {%- do literals.append("'" ~ cleaned | replace("'", "''") ~ "'") -%}
    {%- endif -%}
  {%- endfor -%}
create or replace macro {{ text_cleaner_name() }}(v) as (
  case when lower(trim(v)) in ({{ literals | join(', ') }}) then null else trim(v) end
)
{%- endmacro -%}
