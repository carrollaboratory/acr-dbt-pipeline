with parents as (
    select subject_id, source_snapshot_id, maternal_id as parent_id,
        {{ model_enum_concept('FamilyRelationship', 'relation', 'isBiologicalMotherOf') }} as relation_source
    from {{ ref('cmg_int_subject') }}
    where maternal_id is not null

    union

    select subject_id, source_snapshot_id, paternal_id as parent_id,
        {{ model_enum_concept('FamilyRelationship', 'relation', 'isBiologicalFatherOf') }} as relation_source
    from {{ ref('cmg_int_subject') }}
    where paternal_id is not null
)
select distinct
    {{ generate_md5_global_id(prefix='fr', descriptor=['p.parent_id', 'p.relation_source', 'p.subject_id', 'c.consent_group']) }}::text as family_relationship_id,
    par.subject_gid::text as family_member_id,
    p.relation_source::text as relation_source,
    metadata.concept_curie as relation_concept_curie,
    metadata.concept_display as relation_concept_display,
    metadata.concept_definition as relation_concept_definition,
    metadata.vocabulary_prefix as relation_vocabulary_prefix,
    metadata.fhir_system as relation_fhir_system,
    c.subject_gid::text as subject_id,
    c.access_policy_gid::text as access_policy_id,
    c.study_gid::text as study_id
from parents p
inner join {{ ref('cmg_int_subject') }} c
    on c.subject_id = p.subject_id
    and c.source_snapshot_id = p.source_snapshot_id
inner join {{ ref('cmg_int_subject') }} par
    on par.subject_id = p.parent_id
    and par.source_snapshot_id = p.source_snapshot_id
left join {{ ref('cmg_int_concept_metadata') }} as metadata
    on metadata.source_concept = p.relation_source
