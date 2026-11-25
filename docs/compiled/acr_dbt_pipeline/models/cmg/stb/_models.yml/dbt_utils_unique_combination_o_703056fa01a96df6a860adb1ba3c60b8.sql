





with validation_errors as (

    select
        "File_file_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_external_id"
    group by "File_file_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


