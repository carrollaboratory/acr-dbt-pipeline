





with validation_errors as (

    select
        "EncounterDefinition_encounter_definition_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounterdefinition_external_id"
    group by "EncounterDefinition_encounter_definition_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


