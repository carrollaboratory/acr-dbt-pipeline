





with validation_errors as (

    select
        "Person_person_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_person_external_id"
    group by "Person_person_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


