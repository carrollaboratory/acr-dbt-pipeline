
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sample_id_sample_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_sample_id"
where sample_id_sample_id is null



  
  
      
    ) dbt_internal_test