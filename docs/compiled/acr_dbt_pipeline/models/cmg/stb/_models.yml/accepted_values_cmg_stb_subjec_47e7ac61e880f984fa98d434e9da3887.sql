
    
    

with all_values as (

    select
        subject_type as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_subject"
    group by subject_type

)

select *
from all_values
where value_field not in (
    'CAMO:0000024','CAMO:0000025','CAMO:0000026','CAMO:0000027','CAMO:0000028','snomedct:261665006','snomedct:74964007'
)


