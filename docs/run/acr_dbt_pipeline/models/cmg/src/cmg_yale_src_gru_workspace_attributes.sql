
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_workspace_attributes__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_GRU_20221020_ANV5_202507091800/workspace_attributes-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."attribute" as "attribute",
  "raw"."value" as "value",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast('d3caa579-e6f0-458e-859b-008d89af0b48' as varchar) as source_snapshot_id
from raw
    );
    
  