





with validation_errors as (

    select
        "Demographics_subject_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_external_id"
    group by "Demographics_subject_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


