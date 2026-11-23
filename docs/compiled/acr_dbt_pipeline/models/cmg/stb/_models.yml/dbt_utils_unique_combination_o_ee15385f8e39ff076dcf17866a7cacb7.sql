





with validation_errors as (

    select
        "Aliquot_aliquot_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_aliquot_external_id"
    group by "Aliquot_aliquot_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


