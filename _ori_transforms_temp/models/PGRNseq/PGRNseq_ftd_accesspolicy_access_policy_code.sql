{{ config(materialized='table', schema='PGRNseq_data') }}

{%- set consent_groups = [
    {'consent': 'hmb', 'consents': ['1']},
    {'consent': 'ds', 'consents': ['2']},
    {'consent': 'gru', 'consents': ['3']}
] -%}

    {%- for group in consent_groups -%}
    (
    select DISTINCT 
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs000906') }}::text as "accesspolicy_id",
    '{{ group.consent }}' as "access_policy_code"
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