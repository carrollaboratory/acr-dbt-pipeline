
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    curie as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."tt_curie_harmonization"
where curie is not null
group by curie
having count(*) > 1



  
  
      
    ) dbt_internal_test