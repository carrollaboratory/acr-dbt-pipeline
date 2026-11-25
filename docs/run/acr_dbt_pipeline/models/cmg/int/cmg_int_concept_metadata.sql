
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata__dbt_tmp"
  
    
    as (
      with model_keys as (
    select distinct enumeration_code::text as concept_curie
    from "acr_dbt_pipeline"."main"."model_enums"
),
concept_keys as (
    select
        harmonization.curie::text as source_concept,
        harmonization.harmonized_curie::text as harmonized_curie,
        coalesce(
            model.concept_curie,
            canonical.concept_curie,
            direct.concept_curie,
            harmonization.harmonized_curie
        )::text as concept_lookup_curie
    from "acr_dbt_pipeline"."main_cmg"."tt_curie_harmonization" as harmonization
    left join model_keys as model
        on model.concept_curie = harmonization.curie
    left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concepts" as canonical
        on canonical.concept_curie = harmonization.harmonized_curie
    left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concepts" as direct
        on direct.concept_curie = harmonization.curie

    union all

    select
        concept.concept_curie::text as source_concept,
        concept.concept_curie::text as harmonized_curie,
        concept.concept_curie::text as concept_lookup_curie
    from "acr_dbt_pipeline"."main_cmg"."cmg_int_concepts" as concept
    where not exists (
        select 1
        from "acr_dbt_pipeline"."main_cmg"."tt_curie_harmonization" as harmonization
        where harmonization.curie = concept.concept_curie
    )
)
select
    key.source_concept,
    key.harmonized_curie,
    concept.concept_curie,
    concept.concept_id,
    concept.concept_code,
    concept.display as concept_display,
    concept.definition as concept_definition,
    concept.concept_uri,
    concept.concept_uri_or_curie,
    concept.vocabulary_prefix,
    vocabulary.name as vocabulary_name,
    vocabulary.vocabulary_uri,
    vocabulary.vocabulary_id,
    vocabulary.fhir_system,
    vocabulary.description as vocabulary_description,
    vocabulary.version as vocabulary_version,
    vocabulary.vocabulary_source
from concept_keys as key
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concepts" as concept
    on concept.concept_curie = key.concept_lookup_curie
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_vocabulary" as vocabulary
    on vocabulary.vocabulary_prefix = concept.vocabulary_prefix
    );
    
  