





with validation_errors as (

    select
        "Study_study_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_external_id"
    group by "Study_study_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


