
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_workspace_attributes__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_HMB_GSO_20221020_ANV5_202410011834/workspace_attributes-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."attribute" as "attribute",
  "raw"."value" as "value",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_hmb_gso' as varchar) as source_snapshot,
  cast('5ee23a8c-e9d7-49b9-b23e-ecf1c1cf51a1' as varchar) as source_snapshot_id
from raw
    );
    
  