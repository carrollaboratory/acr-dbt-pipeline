{%- set concept_sources = {
    ref('cmg_main_subject'): [
        {
            'text_column': 'disease_description',
            'concept_column': 'disease_id',
            'text_delimiter': '|',
            'concept_delimiter': '|',
            'dataset_column': 'source_snapshot'
        },
        {
            'text_column': 'phenotype_description',
            'dataset_column': 'source_snapshot'
        },
        {
            'concept_column': 'hpo_present',
            'concept_delimiter': '|',
            'dataset_column': 'source_snapshot'
        },
        {
            'concept_column': 'hpo_absent',
            'concept_delimiter': '|',
            'dataset_column': 'source_snapshot'
        }
    ],
    ref('mapdragon_annotations_talon'): [
        {
            'text_column': 'source_text',
            'concept_column': 'mapped_code',
        },
        {
            'text_column': 'mapped_display',
            'concept_column': 'mapped_code',
        },
        {
            'concept_column': 'mapped_code'
        }
    ]
} -%}

with source_inventory as (
    {{ extract_source_concepts(concept_sources) }}
)
select
    inventory.*,
    metadata.* exclude (source_concept)
from source_inventory as inventory
left join {{ ref('cmg_int_concept_metadata') }} as metadata
    on metadata.source_concept = inventory.normalized_concept
