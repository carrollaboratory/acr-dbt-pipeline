
    
    

with all_values as (

    select
        hash_type as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_hashdigest"
    group by hash_type

)

select *
from all_values
where value_field not in (
    'MS:1000568','CAMO:0000022','MS:1000569','MS:1003151'
)


