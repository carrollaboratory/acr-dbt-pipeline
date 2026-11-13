with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_20250219_ANV5_202502201916/subject-*.parquet')
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
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."phenotype_description" as "phenotype_description",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."paternal_id" as "paternal_id",
  "raw"."maternal_id" as "maternal_id",
  "raw"."ancestry_detail" as "ancestry_detail",
  "raw"."congenital_status" as "congenital_status",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_hmb' as varchar) as source_snapshot,
  cast('1cd2be27-fc8b-4779-9398-d06979ce43c3' as varchar) as source_snapshot_id
from raw