





with validation_errors as (

    select
        "StudyMetadata_study_id", "participant_lifespan_stage"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_participant_lifespan_stage"
    group by "StudyMetadata_study_id", "participant_lifespan_stage"
    having count(*) > 1

)

select *
from validation_errors


