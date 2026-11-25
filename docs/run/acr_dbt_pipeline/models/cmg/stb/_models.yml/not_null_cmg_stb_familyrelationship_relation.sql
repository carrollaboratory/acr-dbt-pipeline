
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select relation
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familyrelationship"
where relation is null



  
  
      
    ) dbt_internal_test