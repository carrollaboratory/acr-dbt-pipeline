
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_YALE_DS_RARED_20221020_ANV5_202409251714/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_rared' as varchar) as source_snapshot,
  cast('e4bc2365-282a-4c51-afe3-971899f61f74' as varchar) as source_snapshot_id
from raw
    );
    
  