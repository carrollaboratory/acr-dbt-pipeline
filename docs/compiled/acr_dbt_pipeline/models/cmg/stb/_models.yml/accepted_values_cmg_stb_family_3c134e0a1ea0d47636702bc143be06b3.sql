
    
    

with all_values as (

    select
        consanguinity as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_family"
    group by consanguinity

)

select *
from all_values
where value_field not in (
    'snomedct:410515003','snomedct:410516002','snomedct:410590009','snomedct:410591008','snomedct:410592001','snomedct:410593006','snomedct:410594000','snomedct:410605003','snomedct:415684004','snomedct:428263003','snomedct:723511001'
)


