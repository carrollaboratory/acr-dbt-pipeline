
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select curie
from "acr_dbt_pipeline"."main_cmg"."tt_curie_harmonization"
where curie is null



  
  
      
    ) dbt_internal_test