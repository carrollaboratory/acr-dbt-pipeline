

select
    vocabulary_prefix,
    name,
    vocabulary_uri,
    vocabulary_id,
    fhir_system,
    description,
    version,
    vocabulary_source
from "acr_dbt_pipeline"."main_cmg"."cmg_int_vocabulary"