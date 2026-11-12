
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_sample__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_IRB_20250224_ANV5_202502241723/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."sample_source" as "sample_source",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_gru_irb' as varchar) as source_snapshot,
  cast('3c279159-bd0e-4df9-bcea-9640e49a694b' as varchar) as source_snapshot_id
from raw
    );
    
  