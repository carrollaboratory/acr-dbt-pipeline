
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select file_file_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_sample_id"
where file_file_id is null



  
  
      
    ) dbt_internal_test