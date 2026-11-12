{%- set sample_cols = [
  'sample_gid', 'sample_id_descriptor',
  'subject_id', 'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor',
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group', 'sequencing_center'
] -%}

with base as (
select
  {{ dbt_utils.star(ref('cmg_main_sequencing'), relation_alias='seq', except=sample_cols) }},
  {% for col in sample_cols -%}
  sa."{{ col }}",
  {% endfor -%}
  {{ generate_global_id(prefix='ay', descriptor=['seq.sequencing_id','sa.consent_group']) }}::text as assay_gid,
  concat('sequencing_id|consent_group:ay-[', seq."sequencing_id", '|', sa."consent_group", ']') AS assay_id_descriptor
from {{ ref('cmg_main_sequencing') }} seq
left join (
select distinct
  sample_id,
  source_snapshot_id,
  {{ sample_cols | join(',\n  ') }}
from {{ ref("cmg_int_sample") }} ) sa
using (sample_id, source_snapshot_id)
)
  
select -- join the annotations
  base.*
from base
