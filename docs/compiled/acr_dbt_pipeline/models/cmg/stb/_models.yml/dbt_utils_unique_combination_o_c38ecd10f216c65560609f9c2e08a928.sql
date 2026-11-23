





with validation_errors as (

    select
        "StudyMetadata_study_id", "clinical_data_source_type"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_clinical_data_source_type"
    group by "StudyMetadata_study_id", "clinical_data_source_type"
    having count(*) > 1

)

select *
from validation_errors


