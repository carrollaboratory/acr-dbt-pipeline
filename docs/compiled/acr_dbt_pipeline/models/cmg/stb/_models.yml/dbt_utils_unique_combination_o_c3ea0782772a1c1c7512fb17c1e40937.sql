





with validation_errors as (

    select
        "FamilyRelationship_family_relationship_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familyrelationship_external_id"
    group by "FamilyRelationship_family_relationship_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


