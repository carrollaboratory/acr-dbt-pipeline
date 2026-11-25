
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select concept_code
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept"
where concept_code is null



  
  
      
    ) dbt_internal_test