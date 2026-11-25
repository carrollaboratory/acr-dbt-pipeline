
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        vital_status as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics"
    group by vital_status

)

select *
from all_values
where value_field not in (
    'snomedct:419099009','snomedct:438949009','snomedct:261665006'
)



  
  
      
    ) dbt_internal_test