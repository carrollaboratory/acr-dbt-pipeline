
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select data_use_permission
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
where data_use_permission is null



  
  
      
    ) dbt_internal_test