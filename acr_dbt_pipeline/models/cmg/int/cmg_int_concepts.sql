with model_concepts as (
    select
        enumeration_code::text as concept_curie,
        split_part(enumeration_code, ':', 1)::text as vocabulary_prefix,
        substr(enumeration_code, strpos(enumeration_code, ':') + 1)::text as concept_code,
        case
            when count(distinct nullif(enumeration_title, '')) > 1
                or count(distinct nullif(enumeration_display, '')) > 1
                then error('Conflicting model_enums metadata for ' || enumeration_code)
            else coalesce(max(nullif(enumeration_title, '')), max(enumeration_display))
        end::text as display,
        max(enumeration_display)::text as definition
    from {{ ref('model_enums') }}
    group by enumeration_code
),
concepts as (
    select
        concept.concept_curie::text as concept_curie,
        ontology.concept_id as concept_id,
        concept.vocabulary_prefix::text as vocabulary_prefix,
        concept.concept_code::text as concept_code,
        concept.display::text as display,
        concept.definition::text as definition
    from model_concepts as concept
    left join {{ source('enrichment', 'tt_concepts') }} as ontology
        on ontology.concept_curie = concept.concept_curie

    union all

    select
        ontology.concept_curie::text as concept_curie,
        ontology.concept_id as concept_id,
        ontology.vocabulary_prefix::text as vocabulary_prefix,
        ontology.concept_code::text as concept_code,
        ontology.display::text as display,
        ontology.definition::text as definition
    from {{ source('enrichment', 'tt_concepts') }} as ontology
    where not exists (
        select 1
        from model_concepts as model
        where model.concept_curie = ontology.concept_curie
    )

    union all

    select distinct
        hardcoded.concept_curie::text as concept_curie,
        null as concept_id,
        split_part(hardcoded.concept_curie, ':', 1)::text as vocabulary_prefix,
        substr(hardcoded.concept_curie, strpos(hardcoded.concept_curie, ':') + 1)::text as concept_code,
        null::text as display,
        null::text as definition
    from {{ ref('hardcoded_concepts') }} as hardcoded
    where not exists (
        select 1
        from model_concepts as model
        where model.concept_curie = hardcoded.concept_curie
    )
    and not exists (
        select 1
        from {{ source('enrichment', 'tt_concepts') }} as ontology
        where ontology.concept_curie = hardcoded.concept_curie
    )
),
concepts_with_uri as (
    select
        concept.*,
        case
            when vocabulary.concept_uri_template like '%[code]%'
                then replace(vocabulary.concept_uri_template, '[code]', concept.concept_code)
            when vocabulary.concept_uri_template is not null
                then vocabulary.concept_uri_template || concept.concept_code
        end::text as concept_uri
    from concepts as concept
    left join {{ ref('cmg_int_vocabulary') }} as vocabulary
        on vocabulary.vocabulary_prefix = concept.vocabulary_prefix
)
select
    *,
    coalesce(concept_uri, concept_curie)::text as concept_uri_or_curie
from concepts_with_uri
