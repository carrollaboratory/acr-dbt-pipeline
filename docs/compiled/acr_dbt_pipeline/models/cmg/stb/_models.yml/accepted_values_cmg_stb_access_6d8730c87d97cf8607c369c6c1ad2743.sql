
    
    

with all_values as (

    select
        data_use_modifier as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
    group by data_use_modifier

)

select *
from all_values
where value_field not in (
    'DUO:00000044','DUO:0000012','DUO:0000015','DUO:0000016','DUO:0000018','DUO:0000019','DUO:0000020','DUO:0000021','DUO:0000022','DUO:0000024','DUO:0000025','DUO:0000026','DUO:0000027','DUO:0000028','DUO:0000029','DUO:0000043','DUO:0000045','DUO:0000046'
)


