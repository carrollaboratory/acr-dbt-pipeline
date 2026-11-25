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
    
  
  
    
    
      
      
        
        
      
        
        
      
        
        
      
        
        
      
        
        
      
      
      
        
      
        
      
    
  
    
    
      
      
        
        
      
        
        
      
      
      
        
      
        
      
    
  
    
    
      
      
        
        
      
      
      
        
      
        
      
    
  
    
    
      
      
        
        
      
        
        
      
        
        
      
        
        
      
      
      
        
      
        
      
    
  

with
  
    
    
      
raw_1_1 as (
    select
        cast("label" as text) as raw_text,
        cast("code" as text) as raw_concept,
        
        null::text[] as source_datasets
        
    from paired_fixture
    group by 1, 2
),
split_1_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        string_split(raw_text, '|') as text_tokens,
        string_split(raw_concept, '|') as concept_tokens
    from raw_1_1
),
paired_1_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_1_1
),
    
  
    
    
      
raw_2_1 as (
    select
        cast(null as text) as raw_text,
        cast("code" as text) as raw_concept,
        
        null::text[] as source_datasets
        
    from code_fixture
    group by 1, 2
),
split_2_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        [raw_text] as text_tokens,
        string_split(raw_concept, '|') as concept_tokens
    from raw_2_1
),
paired_2_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_2_1
),
    
  
    
    
      
raw_3_1 as (
    select
        cast("label" as text) as raw_text,
        cast(null as text) as raw_concept,
        
        null::text[] as source_datasets
        
    from text_fixture
    group by 1, 2
),
split_3_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        [raw_text] as text_tokens,
        [raw_concept] as concept_tokens
    from raw_3_1
),
paired_3_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_3_1
),
    
  
    
    
      
raw_4_1 as (
    select
        cast("label" as text) as raw_text,
        cast("code" as text) as raw_concept,
        
        null::text[] as source_datasets
        
    from alternate_fixture
    group by 1, 2
),
split_4_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        string_split(raw_text, ';') as text_tokens,
        string_split(raw_concept, '::') as concept_tokens
    from raw_4_1
),
paired_4_1 as (
    select
        raw_text,
        raw_concept,
        source_datasets,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_4_1
),
    
  
normalized as (
  
    
    
    
    select
        
        'paired_fixture'::text as table_ref,
        
        source_datasets,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            translate(concept_token, '[]''', '')
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'label'::text as text_column,
        'code'::text as concept_column,
        token_position
    from paired_1_1
      
    union all
      
    
  
    
    
    
    select
        
        'code_fixture'::text as table_ref,
        
        source_datasets,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        null::text as text_column,
        'code'::text as concept_column,
        token_position
    from paired_2_1
      
    union all
      
    
  
    
    
    
    select
        
        'text_fixture'::text as table_ref,
        
        source_datasets,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'label'::text as text_column,
        null::text as concept_column,
        token_position
    from paired_3_1
      
    union all
      
    
  
    
    
    
    select
        
        'alternate_fixture'::text as table_ref,
        
        source_datasets,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'label'::text as text_column,
        'code'::text as concept_column,
        token_position
    from paired_4_1
      
    
  
)
select *
from normalized
where normalized_text is not null or normalized_concept is not null

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