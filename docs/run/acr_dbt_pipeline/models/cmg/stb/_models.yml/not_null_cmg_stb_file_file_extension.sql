
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select file_extension
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file"
where file_extension is null



  
  
      
    ) dbt_internal_test