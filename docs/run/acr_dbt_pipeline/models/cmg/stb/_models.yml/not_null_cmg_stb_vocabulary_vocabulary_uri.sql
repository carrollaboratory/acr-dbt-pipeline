
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select vocabulary_uri
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_vocabulary"
where vocabulary_uri is null



  
  
      
    ) dbt_internal_test