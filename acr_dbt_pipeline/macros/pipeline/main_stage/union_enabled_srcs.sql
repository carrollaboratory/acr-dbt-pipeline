{#-
  Architecture-owned: stacks one table across the selected snapshots.

  Site and consent filters are applied via src_enabled(), allowing the same
  macro to union all snapshots, a single site, or a specific consent cohort.
  UNION ALL BY NAME matches columns by name and fills missing columns with NULL.
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
      "No enabled source models for table '" ~ table_name ~ "' after applying"
      ~ " vars.enabled_srcs, vars.site_filters, vars.consent_filters, and"
      ~ " vars.disabled_src_tables."
    ) -}}
  {%- endif -%}
  {%- for name in active_names %}
select * from {{ ref(src_model_name(name, table_name)) }}
    {%- if not loop.last %}
union all by name
    {%- endif -%}
  {%- endfor -%}
{%- endmacro -%}
