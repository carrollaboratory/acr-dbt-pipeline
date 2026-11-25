
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    source_concept as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata"
where source_concept is not null
group by source_concept
having count(*) > 1



  
  
      
    ) dbt_internal_test