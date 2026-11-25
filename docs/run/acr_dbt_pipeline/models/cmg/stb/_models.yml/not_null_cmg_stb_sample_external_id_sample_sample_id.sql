
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sample_sample_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_external_id"
where sample_sample_id is null



  
  
      
    ) dbt_internal_test