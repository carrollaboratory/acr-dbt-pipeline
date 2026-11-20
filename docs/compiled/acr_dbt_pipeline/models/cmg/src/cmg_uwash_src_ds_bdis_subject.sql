with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_BDIS_20250206_ANV5_202502201850/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."ancestry_detail" as "ancestry_detail",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."family_id" as "family_id",
  "raw"."hpo_present" as "hpo_present",
  "raw"."maternal_id" as "maternal_id",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."paternal_id" as "paternal_id",
  "raw"."phenotype_description" as "phenotype_description",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sample_id" as "sample_id",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."sex" as "sex",
  "raw"."disease_id" as "disease_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_bdis' as varchar) as source_snapshot,
  cast('4312ca34-388a-4d28-baa3-b64ec6eaf7af' as varchar) as source_snapshot_id
from raw