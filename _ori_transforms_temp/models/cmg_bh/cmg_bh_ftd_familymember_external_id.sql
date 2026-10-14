{{ config(materialized='table', schema='cmg_bh_data') }}

select
  distinct
  {{ generate_global_id(prefix='fm',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "familymember_id",
  subject_id::text as "external_id"
from (select distinct subject_id, family_relationship, ingest_provenance from {{ ref('cmg_bh_stg_subject') }}) as s