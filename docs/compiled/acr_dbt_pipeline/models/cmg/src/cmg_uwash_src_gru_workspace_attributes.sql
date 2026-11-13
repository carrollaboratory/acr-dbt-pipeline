with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_20250224_ANV5_202502241706/workspace_attributes-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."attribute" as "attribute",
  "raw"."value" as "value",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_gru' as varchar) as source_snapshot,
  cast('db0c9cff-f3f9-4315-addb-6b6c9088b124' as varchar) as source_snapshot_id
from raw