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
    ]
} -%}

{{ extract_source_concepts(concept_sources) }}
