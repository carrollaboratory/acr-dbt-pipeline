
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_external_id__dbt_tmp"
  
    
    as (
      select distinct
    dataset_gid::text as "dataset_dataset_id",
    source_snapshot_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset"
where source_snapshot_id is not null
    );
    
  