





with validation_errors as (

    select
        "VirtualBiorepository_vbr_id", "contact_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_virtualbiorepository_contact"
    group by "VirtualBiorepository_vbr_id", "contact_id"
    having count(*) > 1

)

select *
from validation_errors


