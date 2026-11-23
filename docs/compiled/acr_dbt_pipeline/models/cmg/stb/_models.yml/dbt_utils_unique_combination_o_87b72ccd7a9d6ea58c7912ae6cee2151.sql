





with validation_errors as (

    select
        "DOI_do_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_doi_external_id"
    group by "DOI_do_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


