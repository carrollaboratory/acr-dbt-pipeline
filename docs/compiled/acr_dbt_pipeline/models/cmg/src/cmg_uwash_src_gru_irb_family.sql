with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_IRB_20250224_ANV5_202502241723/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_gru_irb' as varchar) as source_snapshot,
  cast('3c279159-bd0e-4df9-bcea-9640e49a694b' as varchar) as source_snapshot_id
from raw