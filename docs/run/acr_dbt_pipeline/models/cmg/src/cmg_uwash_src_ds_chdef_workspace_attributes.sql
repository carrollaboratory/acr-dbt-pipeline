
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_workspace_attributes__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_DS_CHDEF_20250224_ANV5_202502241753/workspace_attributes-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."attribute" as "attribute",
  "raw"."value" as "value",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_chdef' as varchar) as source_snapshot,
  cast('10e413c2-729c-4802-a387-6763a7798d8f' as varchar) as source_snapshot_id
from raw
    );
    
  