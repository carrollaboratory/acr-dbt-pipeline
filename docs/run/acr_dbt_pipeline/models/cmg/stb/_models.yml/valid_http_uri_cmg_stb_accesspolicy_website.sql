
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select website as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
where website is not null
  and not 
    regexp_matches(cast(website as TEXT), '^https?://[^\s/$.?#][^\s]*$')



  
  
      
    ) dbt_internal_test