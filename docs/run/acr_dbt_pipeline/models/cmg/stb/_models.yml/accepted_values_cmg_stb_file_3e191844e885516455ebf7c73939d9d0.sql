
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        availability as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file"
    group by availability

)

select *
from all_values
where value_field not in (
    'snomedct:103328004','snomedct:103329007'
)



  
  
      
    ) dbt_internal_test