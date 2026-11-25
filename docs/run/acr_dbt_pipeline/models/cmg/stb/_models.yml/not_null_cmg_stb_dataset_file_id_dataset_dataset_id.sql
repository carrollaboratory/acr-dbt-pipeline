
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select dataset_dataset_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_file_id"
where dataset_dataset_id is null



  
  
      
    ) dbt_internal_test