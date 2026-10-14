{{ config(materialized='table', schema='cmg_bh_data') }}
{%- set consent_groups = ['hmb','irb','npu'] -%}
{%- for grp in consent_groups -%}
        select
      {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "accesspolicy_id",
      '{{ grp }}' as access_policy_code,
    from (select distinct ingest_provenance from {{ ref('cmg_bh_stg_subject') }}) as s
    where s.ingest_provenance ILIKE '{{ grp }}'
    {% if not loop.last %}union all{% endif %}
{% endfor %}