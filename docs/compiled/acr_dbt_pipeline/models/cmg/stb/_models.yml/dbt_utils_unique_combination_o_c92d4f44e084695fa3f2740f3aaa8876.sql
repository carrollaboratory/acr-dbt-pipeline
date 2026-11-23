





with validation_errors as (

    select
        "Record_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_record_external_id"
    group by "Record_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


