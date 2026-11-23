





with validation_errors as (

    select
        "Study_study_id", "funding_source"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study_funding_source"
    group by "Study_study_id", "funding_source"
    having count(*) > 1

)

select *
from validation_errors


