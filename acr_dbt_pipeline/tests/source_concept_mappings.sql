with source_fixture(
    source_snapshot,
    source_snapshot_id,
    source_site,
    consent_group,
    source_relation,
    source_column,
    text_column,
    concept_column,
    raw_text,
    raw_concept,
    normalized_text,
    normalized_concept,
    token_position
) as (
    values
        (
            'cmg_uwash_gru', 'uwash-id', 'cmg_uwash', 'gru',
            'cmg_main_subject', 'disease_description', 'disease_description',
            'disease_id', 'first|second', 'D1|D2', 'first', 'D1', 1
        ),
        (
            'cmg_uwash_gru', 'uwash-id', 'cmg_uwash', 'gru',
            'cmg_main_subject', 'disease_description', 'disease_description',
            'disease_id', 'first|second', 'D1|D2', 'second', 'D2', 2
        ),
        (
            'cmg_uwash_gru', 'uwash-id', 'cmg_uwash', 'gru',
            'cmg_main_subject', 'phenotype_description', 'phenotype_description',
            null, 'first symptom', null, 'first symptom', null, 1
        ),
        (
            'cmg_yale_gru', 'yale-id', 'cmg_yale', 'gru',
            'cmg_main_subject', 'phenotype_description', 'phenotype_description',
            null, 'seizure', null, 'seizure', null, 1
        ),
        (
            'cmg_uwash_gru', 'uwash-id', 'cmg_uwash', 'gru',
            'cmg_main_subject', 'hpo_absent', null,
            'hpo_absent', null, 'HP:0003', null, 'HP:0003', 1
        ),
        (
            'cmg_yale_gru', 'yale-id', 'cmg_yale', 'gru',
            'cmg_main_subject', 'disease_description', 'disease_description',
            'disease_id', 'unknown diagnosis', 'D2', 'unknown diagnosis', 'D2', 1
        )
),
uwash_fixture(original_text, split_text, was_split) as (
    values
        ('first|second', 'diagnosis A', true),
        ('first|second', 'diagnosis B', true),
        ('first symptom', 'symptom A', true),
        ('first symptom', 'symptom B', true),
        ('seizure', 'UWash-only split', true)
),
mapdragon_fixture(table_id, source_text, source_system, mapped_code, mapped_display, mapped_system) as (
    values
        ('d1', 'diagnosis A', 'https://anvilproject.org//disease_description', 'MONDO:1', 'Diagnosis A', 'MONDO'),
        ('d2', 'diagnosis B', 'https://anvilproject.org//disease_description', 'MONDO:2', 'Diagnosis B', 'MONDO'),
        ('p2', 'symptom A', 'https://anvilproject.org//phenotype_description', 'HP:2', 'Symptom A', 'HP'),
        ('p3', 'symptom B', 'https://anvilproject.org//phenotype_description', 'HP:3', 'Symptom B', 'HP'),
        ('p1', 'seizure', 'https://anvilproject.org//phenotype_description', 'HP:1', 'Seizure', 'HP'),
        ('p4', 'UWash-only split', 'https://anvilproject.org//phenotype_description', 'HP:4', 'Wrong source', 'HP'),
        ('h1', 'HP:0003', 'https://anvilproject.org//hpo_absent', 'HP:0003', 'Absent finding', 'HP')
),
actual as (
    {{ map_cmg_source_concepts(
        'source_fixture',
        'mapdragon_fixture',
        'uwash_fixture'
    ) }}
),
actual_projection as (
    select
        source_snapshot,
        source_column,
        raw_text,
        normalized_text,
        raw_concept,
        normalized_concept,
        token_position,
        mapping_lookup_value,
        uwash_original_text,
        uwash_split_text,
        uwash_was_split,
        mapped_code,
        mapping_source_system
    from actual
),
expected(
    source_snapshot,
    source_column,
    raw_text,
    normalized_text,
    raw_concept,
    normalized_concept,
    token_position,
    mapping_lookup_value,
    uwash_original_text,
    uwash_split_text,
    uwash_was_split,
    mapped_code,
    mapping_source_system
) as (
    values
        (
            'cmg_uwash_gru', 'disease_description', 'first|second',
            'first', 'D1|D2', 'D1', 1, 'first',
            null, null, null, null, null
        ),
        (
            'cmg_uwash_gru', 'disease_description', 'first|second',
            'second', 'D1|D2', 'D2', 2, 'second',
            null, null, null, null, null
        ),
        (
            'cmg_uwash_gru', 'disease_description', 'first|second',
            'diagnosis A', null, null, null, 'diagnosis A',
            'first|second', 'diagnosis A', true, 'MONDO:1',
            'https://anvilproject.org//disease_description'
        ),
        (
            'cmg_uwash_gru', 'disease_description', 'first|second',
            'diagnosis B', null, null, null, 'diagnosis B',
            'first|second', 'diagnosis B', true, 'MONDO:2',
            'https://anvilproject.org//disease_description'
        ),
        (
            'cmg_uwash_gru', 'phenotype_description', 'first symptom',
            'first symptom', null, null, 1, 'first symptom',
            null, null, null, null, null
        ),
        (
            'cmg_uwash_gru', 'phenotype_description', 'first symptom',
            'symptom A', null, null, null, 'symptom A',
            'first symptom', 'symptom A', true, 'HP:2',
            'https://anvilproject.org//phenotype_description'
        ),
        (
            'cmg_uwash_gru', 'phenotype_description', 'first symptom',
            'symptom B', null, null, null, 'symptom B',
            'first symptom', 'symptom B', true, 'HP:3',
            'https://anvilproject.org//phenotype_description'
        ),
        (
            'cmg_yale_gru', 'phenotype_description', 'seizure',
            'seizure', null, null, 1, 'seizure',
            null, null, null, 'HP:1',
            'https://anvilproject.org//phenotype_description'
        ),
        (
            'cmg_uwash_gru', 'hpo_absent', null,
            null, 'HP:0003', 'HP:0003', 1, 'HP:0003',
            null, null, null, 'HP:0003',
            'https://anvilproject.org//hpo_absent'
        ),
        (
            'cmg_yale_gru', 'disease_description', 'unknown diagnosis',
            'unknown diagnosis', 'D2', 'D2', 1, 'unknown diagnosis',
            null, null, null, null, null
        )
),
unexpected as (
    select * from actual_projection
    except all
    select * from expected
),
missing as (
    select * from expected
    except all
    select * from actual_projection
)
select 'unexpected' as failure, * from unexpected
union all
select 'missing' as failure, * from missing
