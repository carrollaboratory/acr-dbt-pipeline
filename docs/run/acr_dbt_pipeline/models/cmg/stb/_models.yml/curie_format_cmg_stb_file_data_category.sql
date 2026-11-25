
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select data_category as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file"
where data_category is not null
  and not 
    regexp_matches(cast(data_category as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')



  
  
      
    ) dbt_internal_test