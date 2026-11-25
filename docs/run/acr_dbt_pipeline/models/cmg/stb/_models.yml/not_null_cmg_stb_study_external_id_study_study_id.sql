
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select study_study_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_external_id"
where study_study_id is null



  
  
      
    ) dbt_internal_test