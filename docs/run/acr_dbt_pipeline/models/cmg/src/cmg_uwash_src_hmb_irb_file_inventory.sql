
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_file_inventory__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_HMB_IRB_20250219_ANV5_202502201921/file_inventory-*.parquet')
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
  cast('cmg_uwash_hmb_irb' as varchar) as source_snapshot,
  cast('08568995-f347-4c5a-bd55-d9cc44441e07' as varchar) as source_snapshot_id
from raw
    );
    
  