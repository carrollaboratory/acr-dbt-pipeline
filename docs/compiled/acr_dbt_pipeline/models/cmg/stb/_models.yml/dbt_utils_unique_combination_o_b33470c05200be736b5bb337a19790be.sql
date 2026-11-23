





with validation_errors as (

    select
        "Study_study_id", "principal_investigator_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_principal_investigator"
    group by "Study_study_id", "principal_investigator_id"
    having count(*) > 1

)

select *
from validation_errors


