{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  {{ generate_global_id(prefix='sa',descriptor=['s.ingest_provenance'], study_id='cmg_bh') }}::text as "accesspolicy_id",
  'controlled'::text as "data_access_type"
from (select distinct ingest_provenance from {{ ref('cmg_bh_stg_subject') }}) as s