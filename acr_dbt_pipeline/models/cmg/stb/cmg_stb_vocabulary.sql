{{ config(materialized='table') }}

select
    vocabulary_prefix,
    name,
    vocabulary_uri,
    vocabulary_id,
    fhir_system,
    description,
    version,
    vocabulary_source
from {{ ref('cmg_int_vocabulary') }}