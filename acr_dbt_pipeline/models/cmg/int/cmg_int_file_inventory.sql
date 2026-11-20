-- Common columns in the links ctes
{%- set link_cols = [
  'sequencing_id', 'assay_gid', 'assay_id_descriptor',
  'sample_id', 'sample_gid', 'sample_id_descriptor',
  'subject_id', 'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor'
] -%}
-- Necessary columns from anvil_dataset, used to join the consent, study, etc gids.
{%- set dataset_cols = [
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group'
] -%}

-- This cte handles cleaning file refs within the sequencing table.
with sequencing_links as (
  {%- for col in ['sequencing_id_fileref', 'seq_filename'] %}
  select
    source_snapshot_id,
    cast({{ col }} as varchar) as file_ref,
    {{ link_cols | join(',\n    ') }}
  from {{ ref('cmg_int_sequencing') }}
  where {{ col }} is not null
  {%- if not loop.last %}
  union
  {%- endif %}
  {%- endfor %}
),
-- This cte handles cleaning file refs within the sample table.
-- links identify the sample/subject but cannot identify a sequencing assay.
sample_links as (
  {%- for col in ['cram', 'crai', 'bam'] %}
  select
    source_snapshot_id,
    cast({{ col }} as varchar) as file_ref,
    {%- for c in link_cols %}
    {% if c in ['sequencing_id', 'assay_gid', 'assay_id_descriptor'] -%}
    cast(null as text) as {{ c }}
    {%- else -%}
    {{ c }}
    {%- endif -%}{{ ',' if not loop.last }}
    {%- endfor %}
  from {{ ref('cmg_int_sample') }}
  where {{ col }} is not null
  {%- if not loop.last %}
  union
  {%- endif %}
  {%- endfor %}
),
-- Prefer sequencing links because they also identify the assay. Use a sample
-- link only when that file has no sequencing link in the same snapshot.
links as (
  select * 
  from sequencing_links
  union all
  select sl.*
  from sample_links sl
  where not exists (
    select 1 from sequencing_links q
    where q.source_snapshot_id = sl.source_snapshot_id
      and q.file_ref = sl.file_ref
  )
),

-- Keep every file ref, even when it has no matching sample/sequencing row.
base as (
select
  {{ dbt_utils.star(ref('cmg_main_file_inventory'), relation_alias='fi', except=link_cols + dataset_cols) }},
  {% for col in link_cols -%}
  l."{{ col }}",
  {% endfor -%}
  {% for col in dataset_cols -%}
  ad."{{ col }}",
  {% endfor -%}
  {{ generate_md5_global_id(prefix='fi', descriptor=['fi.file_id','ad.consent_group']) }}::text as file_gid,
  {{ generate_descriptor_for_analysis(prefix='fi', descriptor=['fi.file_id','ad.consent_group']) }}::text as file_id_descriptor
from {{ ref('cmg_main_file_inventory') }} fi
left join links l
  on l.source_snapshot_id = fi.source_snapshot_id
  and l.file_ref = cast(fi.file_ref as varchar)
left join (
select
  source_snapshot_id,
  {{ dataset_cols | join(',\n  ') }}
from {{ ref('cmg_int_anvil_dataset') }} ) ad
  on ad.source_snapshot_id = fi.source_snapshot_id
)

select
  base.*
from base
