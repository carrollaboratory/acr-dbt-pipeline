
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_subject__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_YALE_DS_MC_20221026_ANV5_202409302315/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."ancestry_detail" as "ancestry_detail",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."disease_description" as "disease_description",
  "raw"."family_id" as "family_id",
  "raw"."hpo_present" as "hpo_present",
  "raw"."maternal_id" as "maternal_id",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."paternal_id" as "paternal_id",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."disease_id" as "disease_id",
  "raw"."dbgap_study_id" as "dbgap_study_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_mc' as varchar) as source_snapshot,
  cast('c720c477-dfe2-45e0-805f-94ed11d006b4' as varchar) as source_snapshot_id
from raw
    );
    
  