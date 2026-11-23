





with validation_errors as (

    select
        "FamilyMembership_family_membership_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familymembership_external_id"
    group by "FamilyMembership_family_membership_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


