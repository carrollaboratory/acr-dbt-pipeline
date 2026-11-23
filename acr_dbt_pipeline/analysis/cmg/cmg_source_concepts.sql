-- Fields are defined in cmg_int_source_concepts
select
    table_ref,
    source_datasets,
    raw_text,
    raw_concept,
    normalized_text,
    normalized_concept,
    text_column,
    concept_column,
    token_position
from {{ ref('cmg_int_source_concepts') }}
order by table_ref, concept_column, text_column, raw_concept, raw_text, token_position
