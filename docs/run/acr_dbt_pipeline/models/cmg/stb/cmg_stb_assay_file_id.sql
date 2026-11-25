
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_file_id__dbt_tmp"
  
    
    as (
      select distinct
    assay_gid::text as "assay_assay_id",
    file_gid::text as "file_id_file_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory"
where file_id is not null
and sequencing_id is not null
    );
    
  