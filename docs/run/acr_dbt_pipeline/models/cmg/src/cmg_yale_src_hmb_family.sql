
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_HMB_20221020_ANV5_202410011825/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_hmb' as varchar) as source_snapshot,
  cast('55d26ed5-f046-414f-8c8b-bdc941fa58aa' as varchar) as source_snapshot_id
from raw
    );
    
  