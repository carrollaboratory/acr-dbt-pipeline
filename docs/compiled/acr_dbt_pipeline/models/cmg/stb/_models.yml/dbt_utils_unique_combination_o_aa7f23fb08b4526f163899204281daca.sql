





with validation_errors as (

    select
        "Assay_assay_id", "sample_id_sample_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_sample_id"
    group by "Assay_assay_id", "sample_id_sample_id"
    having count(*) > 1

)

select *
from validation_errors


