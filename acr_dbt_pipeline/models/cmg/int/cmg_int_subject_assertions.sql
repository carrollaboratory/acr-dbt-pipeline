{%- set id_descriptor = [
    'subject_id',
    'study_id',
    'assertion_concept_key',
    'value_concept_source'
] -%}
with matched_source_values as (
    select distinct
        subject.subject_gid::text as subject_id,
        subject.source_snapshot_id::text as source_snapshot_id,
        subject.access_policy_gid::text as access_policy_id,
        subject.study_gid::text as study_id,
        mapping.source_snapshot::text as source_snapshot,
        mapping.source_site::text as source_site,
        mapping.consent_group::text as consent_group,
        mapping.source_column::text as source_column,
        mapping.raw_text::text as raw_text,
        mapping.raw_concept::text as raw_concept,
        mapping.normalized_text::text as normalized_text,
        mapping.normalized_concept::text as normalized_concept,
        mapping.token_position::integer as token_position,
        mapping.uwash_original_text::text as uwash_original_text,
        mapping.uwash_split_text::text as uwash_split_text,
        mapping.mapping_relation::text as mapping_relation,
        mapping.mapping_source_system::text as mapping_source_system,
        mapping.mapping_source_text::text as mapping_source_text,
        mapping.mapping_lookup_value::text as mapping_lookup_value,
        mapping.mapped_code::text as mapped_code,
        mapping.concept_curie::text as concept_curie,
        mapping.concept_uri_or_curie::text as concept_uri_or_curie,
        mapping.concept_display::text as concept_display,
        mapping.concept_definition::text as concept_definition,
        mapping.vocabulary_prefix::text as vocabulary_prefix,
        mapping.fhir_system::text as fhir_system
    from {{ ref('cmg_int_subject') }} as subject
    inner join {{ ref('cmg_int_mappings') }} as mapping
        on mapping.source_snapshot_id::text = subject.source_snapshot_id::text
        and mapping.source_relation = 'cmg_main_subject'
        and (
            (
                mapping.source_column = 'disease_description'
                and mapping.raw_text::text is not distinct from subject.disease_description::text
                and (
                    mapping.raw_concept::text is not distinct from subject.disease_id::text
                    or mapping.uwash_split_text is not null
                )
            )
            or (
                mapping.source_column = 'phenotype_description'
                and mapping.raw_text::text is not distinct from subject.phenotype_description::text
            )
            or (
                mapping.source_column = 'hpo_present'
                and mapping.raw_concept::text is not distinct from subject.hpo_present::text
            )
        )
    where subject.subject_id is not null
),
subject_assertion_candidates as (
    select distinct
        subject_id,
        source_snapshot_id,
        source_snapshot,
        source_site,
        consent_group,
        source_column,
        access_policy_id,
        study_id,
        coalesce(
            mapped_code,
            normalized_concept,
            uwash_split_text,
            normalized_text,
            raw_concept,
            raw_text
        )::text as assertion_concept_key,
        case
            when source_column in ('disease_description', 'phenotype_description')
                then coalesce(uwash_split_text, normalized_text, raw_text, raw_concept)
            else raw_concept
        end::text as concept_source,
        mapped_code,
        concept_curie,
        concept_uri_or_curie,
        concept_display,
        concept_definition,
        vocabulary_prefix,
        fhir_system,
        case source_column
            when 'hpo_present' then {{ hardcoded_concept('hpo_present_value') }}
        end::text as value_concept_source,
        raw_text,
        raw_concept,
        normalized_text,
        normalized_concept,
        token_position,
        uwash_original_text,
        uwash_split_text,
        mapping_relation,
        mapping_source_system,
        mapping_source_text,
        mapping_lookup_value
    from matched_source_values
),
ranked_subject_assertions as (
    select
        *,
        row_number() over (
            partition by
                subject_id,
                study_id,
                (source_column = 'disease_description'),
                assertion_concept_key,
                value_concept_source
            order by
                case when mapped_code is not null then 0 else 1 end,
                concept_source nulls last,
                source_column,
                raw_text nulls last,
                raw_concept nulls last,
                normalized_text nulls last,
                normalized_concept nulls last,
                token_position nulls last,
                mapping_relation nulls last,
                mapping_source_system nulls last,
                mapping_source_text nulls last,
                mapping_lookup_value nulls last,
                source_snapshot_id,
                source_snapshot,
                source_site,
                consent_group,
                access_policy_id
        ) as assertion_source_rank
    from subject_assertion_candidates
),
subject_assertions as (
    select
        case
            when source_column = 'disease_description' then
                replace(
                    {{ generate_md5_global_id(prefix='de', descriptor=id_descriptor) }},
                    'de_',
                    'de-'
                )
            else
                replace(
                    {{ generate_md5_global_id(prefix='ob', descriptor=id_descriptor) }},
                    'ob_',
                    'ob-'
                )
        end::text as assertion_id,
        subject_id,
        source_snapshot_id,
        source_snapshot,
        source_site,
        consent_group,
        source_column,
        access_policy_id,
        study_id,
        concept_source,
        mapped_code,
        concept_curie,
        concept_uri_or_curie,
        concept_display,
        concept_definition,
        vocabulary_prefix,
        fhir_system,
        value_concept_source,
        raw_text,
        raw_concept,
        normalized_text,
        normalized_concept,
        token_position,
        uwash_original_text,
        uwash_split_text,
        mapping_relation,
        mapping_source_system,
        mapping_source_text,
        mapping_lookup_value
    from ranked_subject_assertions
    where assertion_source_rank = 1
)
select
    assertion.*,
    metadata.concept_curie as value_concept_curie,
    metadata.concept_uri_or_curie as value_concept_uri_or_curie,
    metadata.concept_display as value_concept_display,
    metadata.concept_definition as value_concept_definition,
    metadata.vocabulary_prefix as value_vocabulary_prefix,
    metadata.fhir_system as value_fhir_system
from subject_assertions as assertion
left join {{ ref('cmg_int_concept_metadata') }} as metadata
    on metadata.source_concept = assertion.value_concept_source
