
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_sample__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_NBIA_20250206_ANV5_202502201903/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."bam" as "bam",
  "raw"."sample_source" as "sample_source",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_nbia' as varchar) as source_snapshot,
  cast('4a815323-5dc1-4a0c-93c0-1c2333345c4d' as varchar) as source_snapshot_id
from raw
    );
    
  