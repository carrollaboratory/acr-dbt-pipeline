





with validation_errors as (

    select
        "StudyMetadata_study_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_external_id"
    group by "StudyMetadata_study_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


