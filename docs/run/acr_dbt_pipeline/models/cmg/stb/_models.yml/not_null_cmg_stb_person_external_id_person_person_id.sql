
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select person_person_id
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_person_external_id"
where person_person_id is null



  
  
      
    ) dbt_internal_test