
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_subject__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_HMB_20221020_ANV5_202410011825/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."disease_description" as "disease_description",
  "raw"."family_id" as "family_id",
  "raw"."hpo_present" as "hpo_present",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."paternal_id" as "paternal_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_hmb' as varchar) as source_snapshot,
  cast('55d26ed5-f046-414f-8c8b-bdc941fa58aa' as varchar) as source_snapshot_id
from raw
    );
    
  