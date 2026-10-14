{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  distinct
--   { { generate_global_id(prefix='sm',descriptor=['sample_id'], study_id='cmg_bh') }}::text as "parent_sample",
  NULL::text as "parent_sample",
  sample_source::text as "sample_type",
  NULL::text as "availablity_status",
  NULL::text as "quantity_number",
  NULL::text as "quantity_units",
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='sm',descriptor=['sample_id','subject_id'], study_id='cmg_bh') }}::text as "id",
  {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "subject_id",
--   {  { generate_global_id(prefix='bc',descriptor=['sample_id','{TBD}'], study_id='cmg_bh') }}::text as "biospecimen_collection_id"
  NULL::text as "biospecimen_collection_id"
from (select distinct sample_id, subject_id, sample_source, sam.ingest_provenance as ingest_provenance
    from (
        select distinct subject_id, replace(ingest_provenance,'sample_','') as access, ingest_provenance, sample_source, sample_id 
        from {{ ref('cmg_bh_stg_sample') }}
        ) as sam
    left join (
        select distinct subject_id, replace(ingest_provenance,'subject_','') as access, ingest_provenance 
        from {{ ref('cmg_bh_stg_subject') }}
        ) as sub
    using (subject_id, access)
    ) as f