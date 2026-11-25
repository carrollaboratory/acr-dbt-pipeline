
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sex
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics"
where sex is null



  
  
      
    ) dbt_internal_test