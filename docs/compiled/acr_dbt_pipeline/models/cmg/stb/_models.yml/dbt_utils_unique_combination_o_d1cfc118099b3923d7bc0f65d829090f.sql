





with validation_errors as (

    select
        "Family_family_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_family_external_id"
    group by "Family_family_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


