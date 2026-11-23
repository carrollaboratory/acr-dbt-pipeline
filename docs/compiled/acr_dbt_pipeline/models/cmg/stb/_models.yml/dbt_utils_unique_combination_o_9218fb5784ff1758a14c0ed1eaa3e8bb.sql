





with validation_errors as (

    select
        "StudyMetadata_study_id", "study_design_concept_curie"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_study_design"
    group by "StudyMetadata_study_id", "study_design_concept_curie"
    having count(*) > 1

)

select *
from validation_errors


