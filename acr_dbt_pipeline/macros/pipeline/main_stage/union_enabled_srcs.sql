{#-
  Architecture-owned: stacks one table across vars.enabled_srcs.

  UNION ALL BY NAME matches columns by name and fills missing columns with
  NULL. Every selected snapshot must have a
  `<site>_src_<consent>_<table>` model because ref() resolves at parse time.
-#}
{%- macro union_enabled_srcs(table_name) -%}
  {%- set names = enabled_srcs() -%}
  {%- set active_names = [] -%}
  {%- for name in names -%}
    {%- if src_enabled(name, table_name) -%}
      {%- do active_names.append(name) -%}
    {%- endif -%}
  {%- endfor -%}
  {%- if active_names | length == 0 -%}
    {{- exceptions.raise_compiler_error(
      "No enabled source models for table '" ~ table_name ~ "'. Check"
      ~ " vars.enabled_srcs and vars.disabled_src_tables."
    ) -}}
  {%- endif -%}
  {%- for name in active_names %}
select * from {{ ref(src_model_name(name, table_name)) }}
    {%- if not loop.last %}
union all by name
    {%- endif -%}
  {%- endfor -%}
{%- endmacro -%}
