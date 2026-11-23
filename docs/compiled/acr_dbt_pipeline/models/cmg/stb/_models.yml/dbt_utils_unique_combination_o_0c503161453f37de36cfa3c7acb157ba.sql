





with validation_errors as (

    select
        "Sample_sample_id", "processing"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_processing"
    group by "Sample_sample_id", "processing"
    having count(*) > 1

)

select *
from validation_errors


