
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_file_inventory__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_20250224_ANV5_202502241706/file_inventory-*.parquet')
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
  cast('cmg_uwash_gru' as varchar) as source_snapshot,
  cast('db0c9cff-f3f9-4315-addb-6b6c9088b124' as varchar) as source_snapshot_id
from raw
    );
    
  