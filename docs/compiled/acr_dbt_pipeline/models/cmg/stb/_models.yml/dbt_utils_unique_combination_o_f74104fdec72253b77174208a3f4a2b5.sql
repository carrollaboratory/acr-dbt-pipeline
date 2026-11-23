





with validation_errors as (

    select
        "Dataset_dataset_id", "publication_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_publication"
    group by "Dataset_dataset_id", "publication_id"
    having count(*) > 1

)

select *
from validation_errors


