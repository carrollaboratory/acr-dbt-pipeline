with mappings as (
select
  *,
from {{ source('enrichment', 'mapdragon_annotations_talon') }}

union all 

select *
from {{ source('enrichment', 'hardcoded_annotations') }}
)


select     
  mappings.*,
  metadata.* exclude (source_concept)
from mappings
left join {{ ref('cmg_int_concept_metadata') }} as metadata
    on metadata.source_concept = mappings.mapped_code
