





with validation_errors as (

    select
        "File_file_id", "sample_id_sample_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_sample_id"
    group by "File_file_id", "sample_id_sample_id"
    having count(*) > 1

)

select *
from validation_errors


