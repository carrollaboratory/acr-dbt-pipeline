{#-
  Originally sourced from dbt_pipeline_utils (dbt-pipeline-utils repo:
  macros/identifiers/identifiers.sql). Copied locally, not imported; keep in
  sync by hand. Only the md5 global id macros ACR uses are copied.

  md5 method: a gid minted locally from an md5 of normalized column values,
  plus an analysis column showing exactly which values were hashed. Pass
  both macros the same prefix and descriptor list.
-#}

{#-
  Shared by the md5 gid and its analysis descriptor so both use identical
  values: trimmed, internal whitespace collapsed, case kept, '|' escaped as
  '/|', and NULL or blank as ''.
-#}
{%- macro _md5_global_id_values(descriptor=[], macro_name='generate_md5_global_id') -%}
    {%- if descriptor | length == 0 -%}
        {{ exceptions.raise_compiler_error(macro_name ~ " requires at least one descriptor column") }}
    {%- endif -%}
    {%- set values = [] -%}
    {%- for col in descriptor -%}
        {%- do values.append("coalesce(" ~ _normalize_descriptor_part(expr=col, delimiter='|') ~ ", '')") -%}
    {%- endfor -%}
    {{ return(values) }}
{%- endmacro -%}

{#- '<prefix>_' || md5(normalized values joined by '|'). -#}
{%- macro generate_md5_global_id(prefix='', descriptor=[]) -%}
{{
    "'" ~ prefix ~ "' || '_' || md5(" ~ (_md5_global_id_values(descriptor) | join(" || '|' || ")) ~ ")"
}}
{%- endmacro -%}

{#-
  Analysis column showing exactly what a global id was built from, so a
  harmonizer can query it: '<label|label>:<prefix>-[<value|value>]'.
  Takes the same prefix/descriptor args as generate_md5_global_id and uses the
  same normalized values. Labels default to the column names without table
  alias or quotes; pass `labels` to override.
-#}
{%- macro generate_descriptor_for_analysis(prefix='', descriptor=[], labels=none) -%}
    {%- set value_parts = _md5_global_id_values(descriptor, 'generate_descriptor_for_analysis') -%}
    {%- if labels is not none and labels | length != descriptor | length -%}
        {{ exceptions.raise_compiler_error("generate_descriptor_for_analysis: labels and descriptor must have the same length") }}
    {%- endif -%}
    {%- set label_parts = [] -%}
    {%- for col in descriptor -%}
        {%- do label_parts.append(labels[loop.index0] if labels is not none else (col.split('.')[-1] | replace('"', ''))) -%}
    {%- endfor -%}
{{
    "'" ~ (label_parts | join('|')) ~ ":" ~ prefix ~ "-[' || " ~ (value_parts | join(" || '|' || ")) ~ " || ']'"
}}
{%- endmacro -%}

{%- macro _normalize_descriptor_part(
    expr,
    delimiter=',',
    escape_char='/',
    trim_whitespace=true,
    collapse_whitespace=true,
    keep_case=true,
    null_if_blank=true,
    escape_delimiter=true
) -%}

    {%- if expr is none or expr | trim == '' -%}
        {%- do exceptions.raise_compiler_error("normalize_descriptors requires each descriptor entry to include a non-empty expression") -%}
    {%- endif -%}

    {%- set normalized_expr = "cast(" ~ expr ~ " as text)" -%}

    {%- if trim_whitespace -%}
        {%- set normalized_expr = "trim(" ~ normalized_expr ~ ")" -%}
    {%- endif -%}

    {%- if collapse_whitespace -%}
        {%- set normalized_expr = "regexp_replace(" ~ normalized_expr ~ ", '\\s+', ' ', 'g')" -%}
    {%- endif -%}

    {%- if not keep_case -%}
        {%- set normalized_expr = "lower(" ~ normalized_expr ~ ")" -%}
    {%- endif -%}

    {%- if escape_delimiter and delimiter != '' -%}
        {%- set escaped_delimiter = delimiter | replace("'", "''") -%}
        {%- set escaped_replacement = (escape_char ~ delimiter) | replace("'", "''") -%}
        {%- set normalized_expr = "replace(" ~ normalized_expr ~ ", '" ~ escaped_delimiter ~ "', '" ~ escaped_replacement ~ "')" -%}
    {%- endif -%}

    {%- if null_if_blank -%}
        {%- set normalized_expr = "nullif(" ~ normalized_expr ~ ", '')" -%}
    {%- endif -%}

    {{ return(normalized_expr) }}

{%- endmacro -%}
