
  
  
    
    
      
      
        
        
      
        
        
      
        
        
      
        
        
      
      
      
        
      
        
      
    
      
      
        
        
      
      
      
        
      
        
      
    
      
      
        
        
      
        
        
      
      
      
        
      
        
      
    
  
    
    
      
      
        
        
      
        
        
      
      
      
        
      
        
      
    
      
      
        
        
      
        
        
      
      
      
        
      
        
      
    
      
      
        
        
      
      
      
        
      
        
      
    
  

with
  
    
    
      
raw_1_1 as (
    select distinct
        cast("disease_description" as text) as raw_text,
        cast("disease_id" as text) as raw_concept
    from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
),
split_1_1 as (
    select
        raw_text,
        raw_concept,
        string_split(raw_text, '|') as text_tokens,
        string_split(raw_concept, '|') as concept_tokens
    from raw_1_1
),
paired_1_1 as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_1_1
),
    
      
raw_1_2 as (
    select distinct
        cast("phenotype_description" as text) as raw_text,
        cast(null as text) as raw_concept
    from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
),
split_1_2 as (
    select
        raw_text,
        raw_concept,
        [raw_text] as text_tokens,
        [raw_concept] as concept_tokens
    from raw_1_2
),
paired_1_2 as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_1_2
),
    
      
raw_1_3 as (
    select distinct
        cast(null as text) as raw_text,
        cast("hpo_present" as text) as raw_concept
    from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
),
split_1_3 as (
    select
        raw_text,
        raw_concept,
        [raw_text] as text_tokens,
        string_split(raw_concept, '|') as concept_tokens
    from raw_1_3
),
paired_1_3 as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_1_3
),
    
  
    
    
      
raw_2_1 as (
    select distinct
        cast("source_text" as text) as raw_text,
        cast("mapped_code" as text) as raw_concept
    from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
),
split_2_1 as (
    select
        raw_text,
        raw_concept,
        [raw_text] as text_tokens,
        [raw_concept] as concept_tokens
    from raw_2_1
),
paired_2_1 as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_2_1
),
    
      
raw_2_2 as (
    select distinct
        cast("mapped_display" as text) as raw_text,
        cast("mapped_code" as text) as raw_concept
    from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
),
split_2_2 as (
    select
        raw_text,
        raw_concept,
        [raw_text] as text_tokens,
        [raw_concept] as concept_tokens
    from raw_2_2
),
paired_2_2 as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_2_2
),
    
      
raw_2_3 as (
    select distinct
        cast(null as text) as raw_text,
        cast("mapped_code" as text) as raw_concept
    from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
),
split_2_3 as (
    select
        raw_text,
        raw_concept,
        [raw_text] as text_tokens,
        [raw_concept] as concept_tokens
    from raw_2_3
),
paired_2_3 as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_2_3
),
    
  
normalized as (
  
    
    
    
    select
        '"acr_dbt_pipeline"."main_cmg"."cmg_main_subject"'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'disease_description'::text as text_column,
        'disease_id'::text as concept_column,
        token_position
    from paired_1_1
      
    union all
      
    
    select
        '"acr_dbt_pipeline"."main_cmg"."cmg_main_subject"'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'phenotype_description'::text as text_column,
        null::text as concept_column,
        token_position
    from paired_1_2
      
    union all
      
    
    select
        '"acr_dbt_pipeline"."main_cmg"."cmg_main_subject"'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        null::text as text_column,
        'hpo_present'::text as concept_column,
        token_position
    from paired_1_3
      
    union all
      
    
  
    
    
    
    select
        '"acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'source_text'::text as text_column,
        'mapped_code'::text as concept_column,
        token_position
    from paired_2_1
      
    union all
      
    
    select
        '"acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        'mapped_display'::text as text_column,
        'mapped_code'::text as concept_column,
        token_position
    from paired_2_2
      
    union all
      
    
    select
        '"acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          
            concept_token
          
        , '\s+', ' ', 'g')), '') as normalized_concept,
        null::text as text_column,
        'mapped_code'::text as concept_column,
        token_position
    from paired_2_3
      
    
  
)
select *
from normalized
where normalized_text is not null or normalized_concept is not null
