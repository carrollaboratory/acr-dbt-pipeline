{# Architecture-owned: safely builds a DuckDB COLUMNS() name-list literal. #}
{%- macro sql_name_list(names) -%}
  {%- set literals = [] -%}
  {%- for name in names -%}
    {%- do literals.append("'" ~ name | replace("'", "''") ~ "'") -%}
  {%- endfor -%}
  {{- return('[' ~ literals | join(', ') ~ ']') -}}
{%- endmacro -%}
