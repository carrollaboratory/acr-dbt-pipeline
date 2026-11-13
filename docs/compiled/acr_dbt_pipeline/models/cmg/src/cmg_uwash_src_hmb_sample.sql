with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_20250219_ANV5_202502201916/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."sample_source" as "sample_source",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_hmb' as varchar) as source_snapshot,
  cast('1cd2be27-fc8b-4779-9398-d06979ce43c3' as varchar) as source_snapshot_id
from raw