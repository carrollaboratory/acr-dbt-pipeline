with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_RD_20240113_ANV5_202410011804/sample-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sample_id" as "sample_id",
  "raw"."sequencing_center" as "sequencing_center",
  "raw"."subject_id" as "subject_id",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_rd' as varchar) as source_snapshot,
  cast('2df015fc-06f8-46aa-a9ac-e12bc608b2f3' as varchar) as source_snapshot_id
from raw