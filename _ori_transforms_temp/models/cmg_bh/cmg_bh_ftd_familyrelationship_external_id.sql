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
  p.subject_id as "external_id",
  {{ generate_global_id(prefix='fr',descriptor=['family_id','p.subject_id','o.subject_id','other_rel_code'], study_id='cmg_bh') }}::text as "familyrelationship_id"
from probands_only as p
left join others_only as o
using (family_id, ingest_provenance)
where o.subject_id is not null