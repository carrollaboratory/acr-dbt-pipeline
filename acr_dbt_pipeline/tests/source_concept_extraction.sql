-- Synthetic fixtures only: exercise the macro without any pipeline data.
with paired_fixture(label, code) as (
    values
        ('cancer|anxiety|overweight', 'HP:123|HP:456|'),
        ('first|middle|last', 'HP:1||HP:3'),
        ('first|middle|last', 'HP:1||HP:3'),
        ('same|same', 'HP:9|HP:9'),
        ('  O''Brien   syndrome | beta ', '[HP:007]|''HP:008'''),
        (E'\t spaced\nlabel \t', E'\n HP:030\t'),
        (null, 'HP:10|HP:11'),
        ('alone|extra', null),
        (null, null),
        (E'\t', E'\n'),
        (' | ', ' | ')
),
code_fixture(code) as (
    values ('HP:21|HP:20|HP:21|')
),
text_fixture(label) as (
    values ('  A,   B  ')
),
alternate_fixture(label, code) as (
    values ('one;two', 'X::Y::Z')
),
actual as (
    {{ extract_source_concepts({
        'paired_fixture': [{
            'text_column': 'label',
            'concept_column': 'code',
            'text_delimiter': '|',
            'concept_delimiter': '|',
            'concept_strip_chars': "[]'"
        }],
        'code_fixture': [{
            'concept_column': 'code',
            'concept_delimiter': '|'
        }],
        'text_fixture': [{'text_column': 'label'}],
        'alternate_fixture': [{
            'text_column': 'label',
            'concept_column': 'code',
            'text_delimiter': ';',
            'concept_delimiter': '::'
        }]
    }) }}
),
expected(table_ref, raw_text, raw_concept, normalized_text, normalized_concept, text_column, concept_column, token_position) as (
    values
        ('paired_fixture', 'cancer|anxiety|overweight', 'HP:123|HP:456|', 'cancer', 'HP:123', 'label', 'code', 1),
        ('paired_fixture', 'cancer|anxiety|overweight', 'HP:123|HP:456|', 'anxiety', 'HP:456', 'label', 'code', 2),
        ('paired_fixture', 'cancer|anxiety|overweight', 'HP:123|HP:456|', 'overweight', null, 'label', 'code', 3),
        ('paired_fixture', 'first|middle|last', 'HP:1||HP:3', 'first', 'HP:1', 'label', 'code', 1),
        ('paired_fixture', 'first|middle|last', 'HP:1||HP:3', 'middle', null, 'label', 'code', 2),
        ('paired_fixture', 'first|middle|last', 'HP:1||HP:3', 'last', 'HP:3', 'label', 'code', 3),
        ('paired_fixture', 'same|same', 'HP:9|HP:9', 'same', 'HP:9', 'label', 'code', 1),
        ('paired_fixture', 'same|same', 'HP:9|HP:9', 'same', 'HP:9', 'label', 'code', 2),
        ('paired_fixture', '  O''Brien   syndrome | beta ', '[HP:007]|''HP:008''', 'O''Brien syndrome', 'HP:007', 'label', 'code', 1),
        ('paired_fixture', '  O''Brien   syndrome | beta ', '[HP:007]|''HP:008''', 'beta', 'HP:008', 'label', 'code', 2),
        ('paired_fixture', E'\t spaced\nlabel \t', E'\n HP:030\t', 'spaced label', 'HP:030', 'label', 'code', 1),
        ('paired_fixture', null, 'HP:10|HP:11', null, 'HP:10', 'label', 'code', 1),
        ('paired_fixture', null, 'HP:10|HP:11', null, 'HP:11', 'label', 'code', 2),
        ('paired_fixture', 'alone|extra', null, 'alone', null, 'label', 'code', 1),
        ('paired_fixture', 'alone|extra', null, 'extra', null, 'label', 'code', 2),
        ('code_fixture', null, 'HP:21|HP:20|HP:21|', null, 'HP:21', null, 'code', 1),
        ('code_fixture', null, 'HP:21|HP:20|HP:21|', null, 'HP:20', null, 'code', 2),
        ('code_fixture', null, 'HP:21|HP:20|HP:21|', null, 'HP:21', null, 'code', 3),
        ('text_fixture', '  A,   B  ', null, 'A, B', null, 'label', null, 1),
        ('alternate_fixture', 'one;two', 'X::Y::Z', 'one', 'X', 'label', 'code', 1),
        ('alternate_fixture', 'one;two', 'X::Y::Z', 'two', 'Y', 'label', 'code', 2),
        ('alternate_fixture', 'one;two', 'X::Y::Z', null, 'Z', 'label', 'code', 3)
),
unexpected as (
    select * from actual
    except all
    select * from expected
),
missing as (
    select * from expected
    except all
    select * from actual
)
select 'unexpected' as failure, * from unexpected
union all
select 'missing' as failure, * from missing
