
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        "Demographics_subject_id", "race_concept_curie"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_race"
    group by "Demographics_subject_id", "race_concept_curie"
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test