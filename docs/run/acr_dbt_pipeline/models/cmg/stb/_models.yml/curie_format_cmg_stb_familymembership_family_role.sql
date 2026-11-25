
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select family_role as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familymembership"
where family_role is not null
  and not 
    regexp_matches(cast(family_role as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')



  
  
      
    ) dbt_internal_test