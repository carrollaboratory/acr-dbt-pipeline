
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_sample_id__dbt_tmp"
  
    
    as (
      select distinct
    file_gid::text as "file_file_id",
    sample_gid::text as "sample_id_sample_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory"
where file_id is not null
and sample_id is not null
    );
    
  