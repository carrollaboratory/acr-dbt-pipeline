
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select concept_curie
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept"
where concept_curie is null



  
  
      
    ) dbt_internal_test