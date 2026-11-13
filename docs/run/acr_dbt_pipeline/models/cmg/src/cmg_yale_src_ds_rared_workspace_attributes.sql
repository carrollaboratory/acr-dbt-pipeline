
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_workspace_attributes__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_YALE_DS_RARED_20221020_ANV5_202409251714/workspace_attributes-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."attribute" as "attribute",
  "raw"."value" as "value",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_rared' as varchar) as source_snapshot,
  cast('e4bc2365-282a-4c51-afe3-971899f61f74' as varchar) as source_snapshot_id
from raw
    );
    
  