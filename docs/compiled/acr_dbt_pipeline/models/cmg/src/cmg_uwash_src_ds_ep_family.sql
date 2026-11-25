with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_DS_EP_20250219_ANV5_202502201854/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_ep' as varchar) as source_snapshot,
  cast('f71051be-17e3-42bf-b534-5af0e3740937' as varchar) as source_snapshot_id
from raw