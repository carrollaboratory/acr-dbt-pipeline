{%- set concept_sources = {
    ref('cmg_main_subject'): [
        {
            'text_column': 'disease_description',
            'concept_column': 'disease_id',
            'text_delimiter': '|',
            'concept_delimiter': '|'
        },
        {
            'concept_column': 'hpo_present',
            'concept_delimiter': '|'
        }
    ],
    ref('mapdragon_annotations_talon'): [
        {
            'text_column': 'mapped_display',
            'concept_column': 'mapped_code',
            'text_delimiter':'',
            'concept_delimiter':''
        },
        {
            'concept_column': 'mapped_code',
            'concept_delimiter':''
        }
    ]
} -%}

{{ extract_source_concepts(concept_sources) }}
