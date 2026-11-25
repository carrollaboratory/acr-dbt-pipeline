





with validation_errors as (

    select
        "Sample_sample_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_external_id"
    group by "Sample_sample_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


