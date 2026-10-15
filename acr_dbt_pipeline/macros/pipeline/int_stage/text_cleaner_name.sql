{# Architecture-owned: canonical name of the DuckDB value-cleaning macro. #}
{%- macro text_cleaner_name() -%}
  {{- return('acr_clean_text') -}}
{%- endmacro -%}
