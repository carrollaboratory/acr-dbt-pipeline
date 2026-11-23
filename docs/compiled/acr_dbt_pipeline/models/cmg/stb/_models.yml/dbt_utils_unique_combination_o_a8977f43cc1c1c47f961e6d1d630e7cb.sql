





with validation_errors as (

    select
        "VirtualBiorepository_vbr_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_virtualbiorepository_external_id"
    group by "VirtualBiorepository_vbr_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


