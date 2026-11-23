





with validation_errors as (

    select
        "Investigator_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_investigator_external_id"
    group by "Investigator_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


