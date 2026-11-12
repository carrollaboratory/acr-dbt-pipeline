
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_sample__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_GRU_20221020_ANV5_202507091800/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."Participant_id" as "participant_id",
  "raw"."crai" as "crai",
  "raw"."cram" as "cram",
  "raw"."sample_source" as "sample_source",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast('d3caa579-e6f0-458e-859b-008d89af0b48' as varchar) as source_snapshot_id
from raw
    );
    
  