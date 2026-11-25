
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        "Dataset_dataset_id", "file_id_file_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_file_id"
    group by "Dataset_dataset_id", "file_id_file_id"
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test