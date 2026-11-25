





with validation_errors as (

    select
        "Assay_assay_id", "file_id_file_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_file_id"
    group by "Assay_assay_id", "file_id_file_id"
    having count(*) > 1

)

select *
from validation_errors


