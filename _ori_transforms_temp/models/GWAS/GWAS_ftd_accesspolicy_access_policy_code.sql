{{ config(materialized='table', schema='GWAS_data') }}

{%- set consent_groups = [
    {'consent': 'gru', 'consents': ['1', '2', '3', '9']},
    {'consent': 'irb', 'consents': ['2', '3', '9']},
    {'consent': 'col', 'consents': ['3']},
    {'consent': 'npu', 'consents': ['3']},
    {'consent': 'pub', 'consents': ['2', '8', '9']},
    {'consent': 'hmb', 'consents': ['4', '5', '8', '10']},
    {'consent': 'gso', 'consents': ['2', '8', '10']},
    {'consent': 'mds', 'consents': ['5']},
    {'consent': 'ds', 'consents': ['6', '7']}
] -%}

    {%- for group in consent_groups -%}
    (
    select DISTINCT 
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001584') }}::text as "accesspolicy_id",
    '{{ group.consent }}' as "access_policy_code"
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


