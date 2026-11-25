select
    mapping.*,
    metadata.* exclude (source_concept)
from {{ source('enrichment', 'mapdragon_annotations_talon') }} as mapping
left join {{ ref('cmg_int_concept_metadata') }} as metadata
    on metadata.source_concept = mapping.mapped_code
