





with validation_errors as (

    select
        "Dataset_dataset_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_external_id"
    group by "Dataset_dataset_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


