{{ config(materialized='table', schema='cmg_bh_data') }}
with
probands_only as (
    select distinct
      ingest_provenance,
      family_id,
      subject_id,
      family_relationship as "proband_rel_code",
    from {{ ref('cmg_bh_stg_subject') }}
    where family_relationship = 'Proband'
)
,others_only as (
    select distinct
      ingest_provenance,
      family_id,
      subject_id,
      family_relationship as "other_rel_code",
    from {{ ref('cmg_bh_stg_subject') }}
    where family_relationship != 'Proband'
)

select
  distinct
  {{ generate_global_id(prefix='fy',descriptor=['o.family_id'], study_id='cmg_bh') }}::text as "family_id",
  {{ generate_global_id(prefix='fr',descriptor=['p.subject_id','o.subject_id'], study_id='cmg_bh') }}::text as "family_relationships_id"
from probands_only p
left join others_only o
on p.family_id = o.family_id
  and p.ingest_provenance = o.ingest_provenance
where o.subject_id is not null
