





with validation_errors as (

    select
        "File_file_id", "subject_id_subject_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_subject_id"
    group by "File_file_id", "subject_id_subject_id"
    having count(*) > 1

)

select *
from validation_errors


