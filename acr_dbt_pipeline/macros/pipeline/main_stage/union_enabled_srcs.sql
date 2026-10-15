{#-
  Architecture-owned: stacks one table across vars.enabled_srcs.

  UNION ALL BY NAME matches columns by name and fills missing columns with
  NULL. Every selected snapshot must have a
  `<site>_src_<consent>_<table>` model because ref() resolves at parse time.
-#}
{%- macro union_enabled_srcs(table_name) -%}
  {%- set names = enabled_srcs() -%}
  {%- for name in names %}
select * from {{ ref(src_model_name(name, table_name)) }}
    {%- if not loop.last %}
union all by name
    {%- endif -%}
  {%- endfor -%}
{%- endmacro -%}
