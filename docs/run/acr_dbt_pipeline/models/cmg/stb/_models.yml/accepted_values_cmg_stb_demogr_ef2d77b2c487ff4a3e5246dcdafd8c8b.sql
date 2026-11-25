
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        ethnicity as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics"
    group by ethnicity

)

select *
from all_values
where value_field not in (
    'CDCREC:2135-2','CDCREC:2186-5','snomedct:261665006','snomedct:74964007'
)



  
  
      
    ) dbt_internal_test