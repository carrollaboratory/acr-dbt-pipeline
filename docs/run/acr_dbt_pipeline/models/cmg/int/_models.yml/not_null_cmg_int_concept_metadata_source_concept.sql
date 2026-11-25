
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select source_concept
from "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata"
where source_concept is null



  
  
      
    ) dbt_internal_test