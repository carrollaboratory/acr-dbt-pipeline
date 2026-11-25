
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select vocabulary_prefix
from "acr_dbt_pipeline"."main_cmg"."tt_vocabulary"
where vocabulary_prefix is null



  
  
      
    ) dbt_internal_test