{{ config(materialized='table', schema='PGRNseq_data') }}

{%- set consent_groups = [
    {'description': 'Health/Medical/Biomedical', 'consents': ['1']},
    {'description': 'Disease', 'consents': ['2']},
    {'description': 'General Research Use', 'consents': ['3']}
] -%}

    {%- for group in consent_groups -%}
    (
    select DISTINCT
        CASE consent
            WHEN '2' THEN 'Dementia'
            ELSE NULL 
        END as "disease_limitation",
        '{{ group.description }}' as "description",
        NULL as "website",
        {{ generate_global_id(prefix='ap', descriptor=['subjectconsent.consent'], study_id='phs000906') }}::text as "id"
    from {{ ref('PGRNseq_stg_subjectconsent') }} as subjectconsent
      where subjectconsent.consent in (
        {%- for c in group.consents -%}
            '{{ c }}'{% if not loop.last %}, 
          {% endif %}
        {%- endfor -%}
          )
        )
    {% if not loop.last %}union all{% endif %}
    {%- endfor -%}

    