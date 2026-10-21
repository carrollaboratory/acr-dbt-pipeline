{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  NULL::text as "disease_limitation",
  NULL::text as "website", --TODO version of website
    case 
    when ingest_provenance like '%AnVIL_CMG_BaylorHopkins_HMB-IRB-NPU_WES%'
      then 'HMB-IRB-NPU'
    when ingest_provenance like '%AnVIL_CMG_BaylorHopkins_HMB-NPU_WES%'
      then 'HMB-NPU'
    else NULL
  end::text as "description",
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "id"
from (select distinct ingest_provenance from {{ ref('cmg_bh_stg_subject') }}) as s