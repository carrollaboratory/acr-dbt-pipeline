
    
    

with all_values as (

    select
        availability_status as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample"
    group by availability_status

)

select *
from all_values
where value_field not in (
    'snomedct:103328004','snomedct:103329007'
)


