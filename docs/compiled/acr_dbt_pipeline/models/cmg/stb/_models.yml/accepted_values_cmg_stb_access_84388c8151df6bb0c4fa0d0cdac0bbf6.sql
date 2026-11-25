
    
    

with all_values as (

    select
        data_use_permission as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
    group by data_use_permission

)

select *
from all_values
where value_field not in (
    'DUO:0000004','DUO:0000006','DUO:0000007','DUO:0000011','DUO:0000042'
)


