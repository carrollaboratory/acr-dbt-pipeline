
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_family__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_BDIS_20250206_ANV5_202502201850/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_bdis' as varchar) as source_snapshot,
  cast('4312ca34-388a-4d28-baa3-b64ec6eaf7af' as varchar) as source_snapshot_id
from raw
    );
    
  