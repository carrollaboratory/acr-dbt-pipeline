{%- set concept_sources = {
    ref('cmg_main_subject'): [
        {
            'text_column': 'disease_description',
            'concept_column': 'disease_id',
            'text_delimiter': '|',
            'concept_delimiter': '|'
        },
        {
            'text_column': 'phenotype_description'
        },
        {
            'concept_column': 'hpo_present',
            'concept_delimiter': '|'
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

{{ extract_source_concepts(concept_sources) }}
