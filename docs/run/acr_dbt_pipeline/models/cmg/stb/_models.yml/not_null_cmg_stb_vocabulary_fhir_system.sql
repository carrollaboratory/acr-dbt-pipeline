
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select fhir_system
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_vocabulary"
where fhir_system is null



  
  
      
    ) dbt_internal_test