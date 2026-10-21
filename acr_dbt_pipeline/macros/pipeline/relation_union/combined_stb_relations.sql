{%- macro combined_stb_relations(table_name, studies_var) -%}
    {%- set studies = var(studies_var, []) -%}

    {%- if studies | length == 0 -%}
        {{ exceptions.raise_compiler_error("Var '" ~ studies_var ~ "' must contain at least one study prefix.") }}
    {%- endif -%}

    {%- set relations = [] -%}
    {%- for study in studies -%}
        {%- if studies_var == 'common_access_data' -%}
            {%- do relations.append(ref(study ~ '_' ~ table_name)) -%}
        {%- else -%}
            {%- do relations.append(ref(study ~ '_stb_' ~ table_name)) -%}
        {%- endif -%}
    {%- endfor -%}

    {{- return(relations) -}}
{%- endmacro -%}
