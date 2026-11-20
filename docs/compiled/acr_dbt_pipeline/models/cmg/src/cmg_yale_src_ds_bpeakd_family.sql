with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_BPEAKD_20240113_ANV5_202410011754/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_bpeakd' as varchar) as source_snapshot,
  cast('9e210e43-61b5-4a85-8d1a-0abc111f60db' as varchar) as source_snapshot_id
from raw