
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_sample__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_HMB_GSO_20221020_ANV5_202410011834/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."crai" as "crai",
  "raw"."cram" as "cram",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."sample_source" as "sample_source",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_hmb_gso' as varchar) as source_snapshot,
  cast('5ee23a8c-e9d7-49b9-b23e-ecf1c1cf51a1' as varchar) as source_snapshot_id
from raw
    );
    
  