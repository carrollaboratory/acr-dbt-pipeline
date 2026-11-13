
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_HFA_20250206_ANV5_202502201859/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_hfa' as varchar) as source_snapshot,
  cast('98a13ebb-0a91-427e-bdd5-8f5833036d81' as varchar) as source_snapshot_id
from raw
    );
    
  