





with validation_errors as (

    select
        "BiospecimenCollection_biospecimen_collection_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_biospecimencollection_external_id"
    group by "BiospecimenCollection_biospecimen_collection_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


