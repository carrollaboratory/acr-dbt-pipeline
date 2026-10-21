{# Architecture-owned normalization from raw source names to lower snake case. #}
{%- macro snake_case_column_name(name) -%}
  {%- set re = modules.re -%}
  {%- set normalized = re.sub('([A-Z]+)([A-Z][a-z])', '\\g<1>_\\g<2>', name) -%}
  {%- set normalized = re.sub('([a-z0-9])([A-Z])', '\\g<1>_\\g<2>', normalized) -%}
  {%- set normalized = re.sub('[^A-Za-z0-9_]', '_', normalized).lower() -%}
  {%- if normalized == '' -%}
    {{- exceptions.raise_compiler_error(
      "Column name '" ~ name ~ "' does not contain any letters or numbers"
    ) -}}
  {%- endif -%}
  {{- return(normalized) -}}
{%- endmacro -%}
