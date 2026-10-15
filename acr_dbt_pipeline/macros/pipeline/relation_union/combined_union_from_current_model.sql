{%- macro combined_union_from_current_model(studies_var=none) -%}
    {%- if studies_var is none -%}
        {%- if model.name.startswith('inc_program_') -%}
            {%- set studies_var = 'inc_studies' -%}
        {%- elif model.name.startswith('kf_program_') -%}
            {%- set studies_var = 'kf_studies' -%}
        {%- else -%}
            {%- set studies_var = 'combined_studies' -%}
        {%- endif -%}
    {%- endif -%}

    {%- set ns = namespace(table_name=model.name) -%}
    {%- for prefix in ['combined_', 'inc_program_', 'kf_program_'] -%}
        {%- if ns.table_name.startswith(prefix) -%}
            {%- set ns.table_name = ns.table_name.replace(prefix, '', 1) -%}
        {%- endif -%}
    {%- endfor -%}

    {%- if studies_var == 'common_access_data' and ns.table_name.startswith('common_') -%}
        {%- set ns.table_name = ns.table_name.replace('common_', '', 1) -%}
    {%- endif -%}

    {%- set relations = combined_stb_relations(
        table_name=ns.table_name,
        studies_var=studies_var
    ) -%}

    {{- dbt_utils.union_relations(relations=relations) -}}
{%- endmacro -%}
