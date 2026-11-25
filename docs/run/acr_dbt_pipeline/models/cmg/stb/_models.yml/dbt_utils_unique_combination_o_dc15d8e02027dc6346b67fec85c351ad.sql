
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        "Assay_assay_id", "subject_id_subject_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_subject_id"
    group by "Assay_assay_id", "subject_id_subject_id"
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test