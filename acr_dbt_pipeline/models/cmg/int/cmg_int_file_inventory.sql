{%- set link_cols = [
  'sequencing_id', 'assay_gid', 'assay_id_descriptor',
  'sample_id', 'sample_gid', 'sample_id_descriptor',
  'subject_id', 'subject_gid', 'subject_id_descriptor',
  'person_gid', 'person_id_descriptor'
] -%}
{%- set dataset_cols = [
  'study_gid', 'study_id_descriptor',
  'access_policy_gid', 'access_policy_descriptor',
  'consent_group'
] -%}

-- Files carry no sample/sequencing id; sample and sequencing rows point at file_inventory.file_ref.
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
-- a sequencing link already carries the sample/subject, so sample links only fill files sequencing doesn't reach
links as (
  select * from sequencing_links
  union all
  select sl.*
  from sample_links sl
  where not exists (
    select 1 from sequencing_links q
    where q.source_snapshot_id = sl.source_snapshot_id
      and q.file_ref = sl.file_ref
  )
),

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
