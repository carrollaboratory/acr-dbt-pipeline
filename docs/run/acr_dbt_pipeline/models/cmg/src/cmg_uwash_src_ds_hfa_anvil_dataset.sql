
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_anvil_dataset__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_HFA_20250206_ANV5_202502201859/anvil_dataset-*.parquet')
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
  cast('cmg_uwash_ds_hfa' as varchar) as source_snapshot,
  cast('98a13ebb-0a91-427e-bdd5-8f5833036d81' as varchar) as source_snapshot_id
from raw
    );
    
  