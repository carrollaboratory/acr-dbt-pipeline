





with validation_errors as (

    select
        "EncounterDefinition_encounter_definition_id", "activity_definition_id_activity_definition_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounterdefinition_activity_definition_id"
    group by "EncounterDefinition_encounter_definition_id", "activity_definition_id_activity_definition_id"
    having count(*) > 1

)

select *
from validation_errors


