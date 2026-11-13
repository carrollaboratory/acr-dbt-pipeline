
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_sample__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_IRB_20250219_ANV5_202502201921/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_hmb_irb' as varchar) as source_snapshot,
  cast('08568995-f347-4c5a-bd55-d9cc44441e07' as varchar) as source_snapshot_id
from raw
    );
    
  