select
    coalesce(ontology.vocabulary_prefix, details.prefix)::text as vocabulary_prefix,
    coalesce(nullif(ontology.name, ''), details.name)::text as name,
    coalesce(nullif(ontology.vocabulary_uri, ''), nullif(details.uri, ''))::text as vocabulary_uri,
    ontology.vocabulary_id::text as vocabulary_id,
    coalesce(nullif(ontology.fhir_system, ''), details.fhir_system)::text as fhir_system,
    coalesce(nullif(ontology.description, ''), details.description)::text as description,
    ontology.version::text as version,
    case
        when ontology.vocabulary_prefix is null then 'vocabulary_details'
        else ontology.vocabulary_source
    end::text as vocabulary_source,
    coalesce(
        case
            when {{ regex_match('ontology.vocabulary_uri', uri_curie_patterns()['uri']) }}
                and (
                    ontology.vocabulary_uri like '%[code]%'
                    or right(ontology.vocabulary_uri, 1) in ('/', '#', '_', '=')
                )
                then ontology.vocabulary_uri
        end,
        case
            when {{ regex_match('details.uri', uri_curie_patterns()['uri']) }}
                and (
                    details.uri like '%[code]%'
                    or right(details.uri, 1) in ('/', '#', '_', '=')
                )
                then details.uri
        end
    )::text as concept_uri_template
from {{ source('enrichment', 'tt_vocabulary') }} as ontology
full outer join {{ ref('vocabulary_details') }} as details
    on details.prefix = ontology.vocabulary_prefix
