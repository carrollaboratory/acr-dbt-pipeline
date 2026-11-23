





with validation_errors as (

    select
        "Sample_sample_id", "storage_method"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_storage_method"
    group by "Sample_sample_id", "storage_method"
    having count(*) > 1

)

select *
from validation_errors


