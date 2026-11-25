with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_YALE_DS_RARED_20221020_ANV5_202409251714/participant-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."participant_id" as "subject_id",
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
  "raw"."sample_id" as "sample_id",
  "raw"."sex" as "sex",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_rared' as varchar) as source_snapshot,
  cast('e4bc2365-282a-4c51-afe3-971899f61f74' as varchar) as source_snapshot_id
from raw