
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_anvil_dataset__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_DS_EP_20250219_ANV5_202502201854/anvil_dataset-*.parquet')
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
  cast('cmg_uwash_ds_ep' as varchar) as source_snapshot,
  cast('f71051be-17e3-42bf-b534-5af0e3740937' as varchar) as source_snapshot_id
from raw
    );
    
  