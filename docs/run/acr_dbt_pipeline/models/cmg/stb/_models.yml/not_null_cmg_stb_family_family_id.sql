
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select family_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_family"
where family_id is null



  
  
      
    ) dbt_internal_test