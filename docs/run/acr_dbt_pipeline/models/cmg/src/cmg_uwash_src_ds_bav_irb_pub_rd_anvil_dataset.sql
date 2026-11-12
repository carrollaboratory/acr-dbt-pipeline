
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_anvil_dataset__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_BAV_IRB_PUB_RD_20250206_ANV5_202502201846/anvil_dataset-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."dataset_id" as "dataset_id",
  "raw"."consent_group" as "consent_group",
  "raw"."data_use_permission" as "data_use_permission",
  "raw"."owner" as "owner",
  "raw"."principal_investigator" as "principal_investigator",
  "raw"."registered_identifier" as "registered_identifier",
  "raw"."title" as "title",
  "raw"."data_modality" as "data_modality",
  "raw"."source_datarepo_row_ids" as "source_datarepo_row_ids",
  cast('cmg_uwash_ds_bav_irb_pub_rd' as varchar) as source_snapshot,
  cast('b48a3a5c-9d3f-4228-8a24-19f315890f7b' as varchar) as source_snapshot_id
from raw
    );
    
  