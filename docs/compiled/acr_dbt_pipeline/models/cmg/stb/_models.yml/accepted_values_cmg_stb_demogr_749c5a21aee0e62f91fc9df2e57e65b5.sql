
    
    

with all_values as (

    select
        race_concept_curie as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_race"
    group by race_concept_curie

)

select *
from all_values
where value_field not in (
    'CDCREC:1002-5','CDCREC:2028-9','CDCREC:2054-5','CDCREC:2076-8','CDCREC:2106-3','CDCREC:2118-8','snomedct:261665006','snomedct:74964007'
)


