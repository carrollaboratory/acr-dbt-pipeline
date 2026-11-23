





with validation_errors as (

    select
        "Study_study_id", "program"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_program"
    group by "Study_study_id", "program"
    having count(*) > 1

)

select *
from validation_errors


