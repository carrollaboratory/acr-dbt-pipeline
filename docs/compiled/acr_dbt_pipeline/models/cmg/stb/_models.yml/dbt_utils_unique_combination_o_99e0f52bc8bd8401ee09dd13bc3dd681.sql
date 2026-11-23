





with validation_errors as (

    select
        "StudyMetadata_study_id", "research_domain_concept_curie"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_research_domain"
    group by "StudyMetadata_study_id", "research_domain_concept_curie"
    having count(*) > 1

)

select *
from validation_errors


