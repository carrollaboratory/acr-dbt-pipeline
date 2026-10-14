{{ config(materialized='table', schema='cmg_bh_data') }}

select
  sample_id::text as "external_id",
  {{ generate_global_id(prefix='bc',descriptor=['sample_id','sample_source'], study_id='cmg_bh') }}::text as "biospecimencollection_id"
from (select distinct sample_id, sample_source, ingest_provenance
    from (select distinct subject_id, sample_source, sample_id from {{ ref('cmg_bh_stg_sample') }}) as sam
    join (select distinct subject_id, ingest_provenance from {{ ref('cmg_bh_stg_subject') }}) as sub
    using (subject_id)
      )