
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_subject__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_DS_EP_20250219_ANV5_202502201854/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."disease_id" as "disease_id",
  "raw"."family_id" as "family_id",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."phenotype_description" as "phenotype_description",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."hpo_present" as "hpo_present",
  "raw"."maternal_id" as "maternal_id",
  "raw"."paternal_id" as "paternal_id",
  "raw"."solve_state" as "solve_state",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_ep' as varchar) as source_snapshot,
  cast('f71051be-17e3-42bf-b534-5af0e3740937' as varchar) as source_snapshot_id
from raw
    );
    
  