





with validation_errors as (

    select
        "Publication_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_publication_external_id"
    group by "Publication_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


