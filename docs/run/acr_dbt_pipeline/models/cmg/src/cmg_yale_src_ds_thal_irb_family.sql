
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_THAL_IRB_20240113_ANV5_202410011814/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_thal_irb' as varchar) as source_snapshot,
  cast('c68d1d19-aac9-4042-ab62-5f40837fe10d' as varchar) as source_snapshot_id
from raw
    );
    
  