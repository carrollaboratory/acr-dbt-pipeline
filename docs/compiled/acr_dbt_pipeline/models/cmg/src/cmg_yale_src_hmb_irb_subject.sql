with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_HMB_IRB_20240113_ANV5_202410011846/subject-*.parquet')
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
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_hmb_irb' as varchar) as source_snapshot,
  cast('39fd1d5b-2e6f-4035-beb3-05322174dd4b' as varchar) as source_snapshot_id
from raw