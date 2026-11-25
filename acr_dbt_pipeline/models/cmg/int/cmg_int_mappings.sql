with source_context as (
    select distinct
        s.source_snapshot::text as source_snapshot,
        s.source_snapshot_id::text as source_snapshot_id,
        concat('cmg_', split_part(s.source_snapshot, '_', 2))::text as source_site,
        ad.consent_group::text as consent_group,
        s.disease_description::text as disease_description,
        s.disease_id::text as disease_id,
        s.phenotype_description::text as phenotype_description,
        s.hpo_present::text as hpo_present
    from {{ ref('cmg_main_subject') }} s
    left join {{ ref('cmg_int_anvil_dataset') }} ad
        using (source_snapshot_id)
),
source_values as (
    select distinct
        source_snapshot,
        source_snapshot_id,
        source_site,
        consent_group,
        'cmg_main_subject'::text as source_relation,
        'disease_description'::text as source_column,
        'disease_description'::text as text_column,
        'disease_id'::text as concept_column,
        disease_description as raw_text,
        disease_id as raw_concept
    from source_context
    where disease_description is not null or disease_id is not null

    union all

    select distinct
        source_snapshot,
        source_snapshot_id,
        source_site,
        consent_group,
        'cmg_main_subject'::text as source_relation,
        'phenotype_description'::text as source_column,
        'phenotype_description'::text as text_column,
        null::text as concept_column,
        phenotype_description as raw_text,
        null::text as raw_concept
    from source_context
    where phenotype_description is not null

    union all

    select distinct
        source_snapshot,
        source_snapshot_id,
        source_site,
        consent_group,
        'cmg_main_subject'::text as source_relation,
        'hpo_present'::text as source_column,
        null::text as text_column,
        'hpo_present'::text as concept_column,
        null::text as raw_text,
        hpo_present as raw_concept
    from source_context
    where hpo_present is not null
),
source_concepts as (
    select distinct
        source.source_snapshot,
        source.source_snapshot_id,
        source.source_site,
        source.consent_group,
        source.source_relation,
        source.source_column,
        concept.text_column,
        concept.concept_column,
        concept.raw_text,
        concept.raw_concept,
        concept.normalized_text,
        concept.normalized_concept,
        concept.token_position,
        concept.source_datasets
    from source_values source
    inner join {{ ref('cmg_int_source_concepts') }} concept
        on concept.text_column is not distinct from source.text_column
        and concept.concept_column is not distinct from source.concept_column
        and concept.raw_text is not distinct from source.raw_text
        and concept.raw_concept is not distinct from source.raw_concept
),
mapped_source_concepts as (
    {{ map_cmg_source_concepts(
        'source_concepts',
        ref('mapdragon_annotations_talon'),
        ref('uwash_split_text_mapping_disease_and_phenotype')
    ) }}
)
select
    mapping.*,
    coalesce(mapping.mapped_code, mapping.normalized_concept) as concept_lookup_source,
    metadata.* exclude (source_concept)
from mapped_source_concepts as mapping
left join {{ ref('cmg_int_concept_metadata') }} as metadata
    on metadata.source_concept = coalesce(mapping.mapped_code, mapping.normalized_concept)