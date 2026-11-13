
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_RD_20240113_ANV5_202410011804/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_rd' as varchar) as source_snapshot,
  cast('2df015fc-06f8-46aa-a9ac-e12bc608b2f3' as varchar) as source_snapshot_id
from raw
    );
    
  