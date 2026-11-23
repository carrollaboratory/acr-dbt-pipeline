





with validation_errors as (

    select
        "ActivityDefinition_activity_definition_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_activitydefinition_external_id"
    group by "ActivityDefinition_activity_definition_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


