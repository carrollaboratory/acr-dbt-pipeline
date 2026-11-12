
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_file_inventory__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_BDIS_20250206_ANV5_202502201850/file_inventory-*.parquet')
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
  cast('cmg_uwash_ds_bdis' as varchar) as source_snapshot,
  cast('4312ca34-388a-4d28-baa3-b64ec6eaf7af' as varchar) as source_snapshot_id
from raw
    );
    
  