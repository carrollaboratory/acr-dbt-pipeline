
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_subject__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_20250224_ANV5_202502241706/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
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
  "raw"."ancestry" as "ancestry",
  "raw"."disease_id" as "disease_id",
  "raw"."disease_description" as "disease_description",
  "raw"."congenital_status" as "congenital_status",
  "raw"."ancestry_detail" as "ancestry_detail",
  "raw"."dbgap_study_id" as "dbgap_study_id",
  "raw"."dbgap_subject_id" as "dbgap_subject_id",
  "raw"."pmid_id" as "pmid_id",
  "raw"."solve_state" as "solve_state",
  "raw"."prior_testing" as "prior_testing",
  "raw"."age_at_last_observation" as "age_at_last_observation",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_gru' as varchar) as source_snapshot,
  cast('db0c9cff-f3f9-4315-addb-6b6c9088b124' as varchar) as source_snapshot_id
from raw
    );
    
  