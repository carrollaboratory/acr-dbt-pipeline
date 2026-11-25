
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_hash__dbt_tmp"
  
    
    as (
      select distinct
    fi.file_gid::text as "file_file_id",
    hd.id::integer as "hash_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory" fi
inner join "acr_dbt_pipeline"."main_cmg"."cmg_stb_hashdigest" hd
on hd.hash_value = fi.md5_hash
where fi.file_id is not null
    );
    
  