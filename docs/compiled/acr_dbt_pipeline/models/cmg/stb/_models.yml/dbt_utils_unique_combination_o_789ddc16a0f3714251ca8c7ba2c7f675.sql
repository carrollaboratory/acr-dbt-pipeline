





with validation_errors as (

    select
        "Encounter_encounter_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounter_external_id"
    group by "Encounter_encounter_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


