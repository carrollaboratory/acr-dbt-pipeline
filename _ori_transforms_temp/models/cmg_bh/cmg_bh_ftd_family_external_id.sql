{{ config(materialized='table', schema='cmg_bh_data') }}

select
  distinct
  {{ generate_global_id(prefix='fm',descriptor=['family_id'], study_id='cmg_bh') }}::text as "family_id",
  family_id::text as "external_id"
from (select distinct family_id, ingest_provenance from {{ ref('cmg_bh_stg_subject') }})