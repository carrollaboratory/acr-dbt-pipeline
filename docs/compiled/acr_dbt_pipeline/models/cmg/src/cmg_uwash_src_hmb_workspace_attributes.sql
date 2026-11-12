with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_20250219_ANV5_202502201916/workspace_attributes-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."attribute" as "attribute",
  "raw"."value" as "value",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_hmb' as varchar) as source_snapshot,
  cast('1cd2be27-fc8b-4779-9398-d06979ce43c3' as varchar) as source_snapshot_id
from raw