{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  '07b0243c-48fc-4eee-a338-c7571cc2df1a'::text as "snapshot_id",
  'datarepo-d321333c'::text as "google_data_project",
  'ANVIL_CMG_BaylorHopkins_HMB_NPU_WES_20230525_ANV5_202402290537'::text as "snapshot_dataset",
  NULL::text as "table",
  NULL::text as "parameterized_query",
  {{ generate_global_id(prefix='ds',descriptor=['dbgap_study_id'], study_id='cmg_bh') }}::text as "id"
from (select distinct dbgap_study_id from {{ ref('cmg_bh_stg_subject') }} ) as s
