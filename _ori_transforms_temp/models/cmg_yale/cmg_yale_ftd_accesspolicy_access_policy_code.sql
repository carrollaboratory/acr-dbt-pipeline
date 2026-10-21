{{ config(materialized='table', schema='cmg_yale_data') }}
{%- set consent_groups = ['gru','ds','gso','hmb','irb','pub','col','npu','mds','gsr'] -%}

{%- for grp in consent_groups -%}
        select
      {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cmg_yale') }}::text as "accesspolicy_id",
      '{{ grp }}' as access_policy_code,
      consent_id as "ftd_consent_group"
    from (select distinct consent_id from {{ ref('cmg_yale_stg_subject') }}) as s
    where s.consent_id ILIKE '%{{ grp }}%'
    {% if not loop.last %}union all{% endif %}
{% endfor %}