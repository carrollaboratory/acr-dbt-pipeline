
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_anvil_dataset__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_THAL_IRB_20240113_ANV5_202410011814/anvil_dataset-*.parquet')
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
  cast('cmg_yale_ds_thal_irb' as varchar) as source_snapshot,
  cast('c68d1d19-aac9-4042-ab62-5f40837fe10d' as varchar) as source_snapshot_id
from raw
    );
    
  