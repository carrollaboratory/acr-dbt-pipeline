
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_20250219_ANV5_202502201916/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."family_history" as "family_history",
  "raw"."consanguinity_detail" as "consanguinity_detail",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_hmb' as varchar) as source_snapshot,
  cast('1cd2be27-fc8b-4779-9398-d06979ce43c3' as varchar) as source_snapshot_id
from raw
    );
    
  