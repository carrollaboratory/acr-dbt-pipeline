
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select study_description
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study"
where study_description is null



  
  
      
    ) dbt_internal_test