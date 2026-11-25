





with validation_errors as (

    select
        "Assay_assay_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_external_id"
    group by "Assay_assay_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


