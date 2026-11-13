
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_HMB_IRB_20240113_ANV5_202410011846/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_hmb_irb' as varchar) as source_snapshot,
  cast('39fd1d5b-2e6f-4035-beb3-05322174dd4b' as varchar) as source_snapshot_id
from raw
    );
    
  