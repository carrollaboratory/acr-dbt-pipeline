
    
    

with all_values as (

    select
        family_type as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_family"
    group by family_type

)

select *
from all_values
where value_field not in (
    'CAMO:0000002','CAMO:0000003','CAMO:0000004','CAMO:0000005','CAMO:0000006','CAMO:0000007','CAMO:0000008'
)


