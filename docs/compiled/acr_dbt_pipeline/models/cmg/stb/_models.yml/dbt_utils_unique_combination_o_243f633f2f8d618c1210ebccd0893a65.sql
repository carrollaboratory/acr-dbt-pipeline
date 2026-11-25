





with validation_errors as (

    select
        "File_file_id", "hash_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_hash"
    group by "File_file_id", "hash_id"
    having count(*) > 1

)

select *
from validation_errors


