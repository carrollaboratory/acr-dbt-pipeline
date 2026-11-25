
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select race_concept_curie
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_race"
where race_concept_curie is null



  
  
      
    ) dbt_internal_test