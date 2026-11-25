with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_RD_20240113_ANV5_202410011804/subject-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."subject_id" as "subject_id",
  "raw"."affected_status" as "affected_status",
  "raw"."ancestry" as "ancestry",
  "raw"."ancestry_detail" as "ancestry_detail",
  "raw"."dbgap_submission" as "dbgap_submission",
  "raw"."disease_description" as "disease_description",
  "raw"."disease_id" as "disease_id",
  "raw"."family_id" as "family_id",
  "raw"."hpo_present" as "hpo_present",
  "raw"."multiple_datasets" as "multiple_datasets",
  "raw"."proband_relationship" as "proband_relationship",
  "raw"."project_id" as "project_id",
  "raw"."sex" as "sex",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_rd' as varchar) as source_snapshot,
  cast('2df015fc-06f8-46aa-a9ac-e12bc608b2f3' as varchar) as source_snapshot_id
from raw