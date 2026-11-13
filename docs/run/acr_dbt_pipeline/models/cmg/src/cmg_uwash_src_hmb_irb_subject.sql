
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_subject__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_IRB_20250219_ANV5_202502201921/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."family_id" as "family_id",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."phenotype_description" as "phenotype_description",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."hpo_present" as "hpo_present",
  "raw"."maternal_id" as "maternal_id",
  "raw"."paternal_id" as "paternal_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_hmb_irb' as varchar) as source_snapshot,
  cast('08568995-f347-4c5a-bd55-d9cc44441e07' as varchar) as source_snapshot_id
from raw
    );
    
  