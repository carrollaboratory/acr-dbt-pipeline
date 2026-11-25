with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_THAL_IRB_20240113_ANV5_202410011814/file_inventory-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."file_id" as "file_id",
  "raw"."name" as "name",
  "raw"."path" as "path",
  "raw"."uri" as "uri",
  "raw"."content_type" as "content_type",
  "raw"."full_extension" as "full_extension",
  "raw"."size_in_bytes" as "size_in_bytes",
  "raw"."crc32c" as "crc32c",
  "raw"."md5_hash" as "md5_hash",
  "raw"."file_ref" as "file_ref",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_thal_irb' as varchar) as source_snapshot,
  cast('c68d1d19-aac9-4042-ab62-5f40837fe10d' as varchar) as source_snapshot_id
from raw