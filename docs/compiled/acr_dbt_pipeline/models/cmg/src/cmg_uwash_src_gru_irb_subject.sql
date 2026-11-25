with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_IRB_20250224_ANV5_202502241723/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."disease_id" as "disease_id",
  "raw"."family_id" as "family_id",
  "raw"."hpo_present" as "hpo_present",
  "raw"."maternal_id" as "maternal_id",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."paternal_id" as "paternal_id",
  "raw"."phenotype_description" as "phenotype_description",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."solve_state" as "solve_state",
  "raw"."pmid_id" as "pmid_id",
  "raw"."twin_id" as "twin_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_gru_irb' as varchar) as source_snapshot,
  cast('3c279159-bd0e-4df9-bcea-9640e49a694b' as varchar) as source_snapshot_id
from raw