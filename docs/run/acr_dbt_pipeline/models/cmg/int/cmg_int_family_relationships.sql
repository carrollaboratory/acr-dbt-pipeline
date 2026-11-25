
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_family_relationships__dbt_tmp"
  
    
    as (
      with parents as (
    select subject_id, source_snapshot_id, maternal_id as parent_id,
        
    coalesce(
        (
            select distinct nullif(enumeration_code, '')
            from "acr_dbt_pipeline"."main"."model_enums"
            where table_name = 'FamilyRelationship'
              and variable_name = 'relation'
              and enumeration_title = 'isBiologicalMotherOf'
        ),
        error('model_enums has no code for FamilyRelationship.relation: isBiologicalMotherOf')
    )
 as relation_source
    from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
    where maternal_id is not null

    union

    select subject_id, source_snapshot_id, paternal_id as parent_id,
        
    coalesce(
        (
            select distinct nullif(enumeration_code, '')
            from "acr_dbt_pipeline"."main"."model_enums"
            where table_name = 'FamilyRelationship'
              and variable_name = 'relation'
              and enumeration_title = 'isBiologicalFatherOf'
        ),
        error('model_enums has no code for FamilyRelationship.relation: isBiologicalFatherOf')
    )
 as relation_source
    from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
    where paternal_id is not null
)
select distinct
    'fr' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(p.parent_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(p.relation_source as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(p.subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(c.consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as family_relationship_id,
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
inner join "acr_dbt_pipeline"."main_cmg"."cmg_int_subject" c
    on c.subject_id = p.subject_id
    and c.source_snapshot_id = p.source_snapshot_id
inner join "acr_dbt_pipeline"."main_cmg"."cmg_int_subject" par
    on par.subject_id = p.parent_id
    and par.source_snapshot_id = p.source_snapshot_id
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata" as metadata
    on metadata.source_concept = p.relation_source
    );
    
  