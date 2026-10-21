{{ config(materialized='table', schema='GWAS_data') }}

{%- set consent_groups = [
    {'description': 'General Research Use', 'consents': ['1', '2', '3', '9']},
    {'description': 'IRB Approval Required', 'consents': ['2', '3', '9']},
    {'description': 'Collaboration Required', 'consents': ['3']},
    {'description': 'Not-for-profit use only', 'consents': ['3']},
    {'description': 'Publication Required', 'consents': ['2', '8', '9']},
    {'description': 'Health/Medical/Biomedical', 'consents': ['4', '5', '8', '10']},
    {'description': 'Genetic Studies only', 'consents': ['2', '8', '10']},
    {'description': 'Methods', 'consents': ['5']},
    {'description': 'Disease', 'consents': ['6', '7']}
] -%}

with source as (
    {%- for group in consent_groups -%}
    (
    select DISTINCT
        CASE consent
            WHEN '6' THEN 'Childhood Diseases'
            WHEN '7' THEN 'Dementia'
            ELSE NULL 
        END as "disease_limitation",
        '{{ group.description }}' as "description",
        NULL as "website",
        {{ generate_global_id(prefix='ap', descriptor=['subjectconsent.consent'], study_id='phs001584') }}::text as "id"
    from {{ ref('GWAS_stg_subjectconsent') }} as subjectconsent
      where subjectconsent.consent in (
        {%- for c in group.consents -%}
            '{{ c }}'{% if not loop.last %}, 
          {% endif %}
        {%- endfor -%}
          )
        )
    {% if not loop.last %}union all{% endif %}
    {%- endfor -%}

)
select * from source

    