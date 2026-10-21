{{ config(materialized='table', schema='GWAS_data') }}

select DISTINCT
  {{ generate_global_id(prefix='sm',descriptor=['samplesubjectmapping.subject_id', 'samplesubjectmapping.source_sampid'], study_id='phs001584') }}::text as  "sample_id",
  samplesubjectmapping.source_sampid::text as "external_id"
from {{ ref('GWAS_stg_samplesubjectmapping') }} as samplesubjectmapping

