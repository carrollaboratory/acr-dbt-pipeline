{#-
  Installs a DuckDB macro that blanks/sentinels a text value to NULL.

  Defining this once in the database keeps the per-model compiled SQL short:
  models call acr_clean_text(...) instead of repeating a CASE expression for
  every column. It is created by the on-run-start hook in dbt_project.yml.
-#}
{%- macro text_cleaner_name() -%}
  {{- return('acr_clean_text') -}}
{%- endmacro -%}

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

{%- macro sql_name_list(names) -%}
  {%- set literals = [] -%}
  {%- for name in names -%}
    {%- do literals.append("'" ~ name | replace("'", "''") ~ "'") -%}
  {%- endfor -%}
  {{- return('[' ~ literals | join(', ') ~ ']') -}}
{%- endmacro -%}
