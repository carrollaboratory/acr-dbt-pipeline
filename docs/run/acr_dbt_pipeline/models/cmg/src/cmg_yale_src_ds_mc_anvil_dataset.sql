
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_anvil_dataset__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_YALE_DS_MC_20221026_ANV5_202409302315/anvil_dataset-*.parquet')
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
  cast('cmg_yale_ds_mc' as varchar) as source_snapshot,
  cast('c720c477-dfe2-45e0-805f-94ed11d006b4' as varchar) as source_snapshot_id
from raw
    );
    
  