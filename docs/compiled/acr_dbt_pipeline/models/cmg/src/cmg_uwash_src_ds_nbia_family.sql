with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_NBIA_20250206_ANV5_202502201903/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_nbia' as varchar) as source_snapshot,
  cast('4a815323-5dc1-4a0c-93c0-1c2333345c4d' as varchar) as source_snapshot_id
from raw