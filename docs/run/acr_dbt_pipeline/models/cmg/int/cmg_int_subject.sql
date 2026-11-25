
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_subject__dbt_tmp"
  
    
    as (
      with base as ( -- join the base table to anvil_dataset
  select 
    s."datarepo_row_id",
  s."subject_id",
  s."affected_status",
  s."ancestry",
  s."ancestry_detail",
  s."dbgap_study_id",
  s."dbgap_submission",
  s."disease_description",
  s."disease_id",
  s."family_id",
  s."hpo_present",
  s."multiple_datasets",
  s."proband_relationship",
  s."project_id",
  s."sex",
  s."maternal_id",
  s."paternal_id",
  s."ingest_provenance",
  s."source_snapshot",
  s."source_snapshot_id",
  s."sample_id",
  s."phenotype_description",
  s."congenital_status",
  s."dbgap_subject_id",
  s."pmid_id",
  s."solve_state",
  s."prior_testing",
  s."age_at_last_observation",
  s."twin_id",
  s."sequencing_center",
    ad."registered_identifier",
  ad."consent_group",
  ad."study_gid",
  ad."access_policy_gid",
  ad."study_id_descriptor",
  ad."access_policy_descriptor",
  ad."data_use_permission_concept_curie",
  ad."data_use_permission_concept_display",
  ad."data_use_permission_concept_definition",
  ad."data_use_permission_vocabulary_prefix",
  ad."data_use_permission_fhir_system",
  ad."data_use_modifier_concept_curie",
  ad."data_use_modifier_concept_display",
  ad."data_use_modifier_concept_definition",
  ad."data_use_modifier_vocabulary_prefix",
  ad."data_use_modifier_fhir_system",
    'sb' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as subject_gid,
    'subject_id|consent_group:sb-[' || coalesce(nullif(replace(regexp_replace(trim(cast(subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as subject_id_descriptor,
    'pr' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as person_gid,
    'subject_id|consent_group:pr-[' || coalesce(nullif(replace(regexp_replace(trim(cast(subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as person_id_descriptor,
    
    coalesce(
        (
            select distinct nullif(enumeration_code, '')
            from "acr_dbt_pipeline"."main"."model_enums"
            where table_name = 'Subject'
              and variable_name = 'subject_type'
              and enumeration_title = 'Participant'
        ),
        error('model_enums has no code for Subject.subject_type: Participant')
    )
::text as subject_type_source,
    
    coalesce(
        (
            select nullif(concept_curie, '')
            from "acr_dbt_pipeline"."main"."hardcoded_concepts"
            where model_variable = 'organism_type'
        ),
        error('hardcoded_concepts has no CURIE for model_variable organism_type')
    )
::text as organism_type_source
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject" s
  left join "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset" ad
  using(source_snapshot_id)
  ),

affected_status_mappings as (
  select
    source_text::text as affected_status,
    mapped_code::text as affected_status_mapped_code,
    
    concept_curie as affected_status_concept_curie,
    
    concept_display as affected_status_concept_display,
    
    concept_definition as affected_status_concept_definition,
    
    vocabulary_prefix as affected_status_vocabulary_prefix,
    
    fhir_system as affected_status_fhir_system,
    
    concept_uri_or_curie as affected_status_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//affected_status'
),

ancestry_mappings as (
  select
    source_text::text as ancestry,
    mapped_code::text as ancestry_mapped_code,
    
    concept_curie as ancestry_concept_curie,
    
    concept_display as ancestry_concept_display,
    
    concept_definition as ancestry_concept_definition,
    
    vocabulary_prefix as ancestry_vocabulary_prefix,
    
    fhir_system as ancestry_fhir_system,
    
    concept_uri_or_curie as ancestry_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//ancestry'
),

congenital_status_mappings as (
  select
    source_text::text as congenital_status,
    mapped_code::text as congenital_status_mapped_code,
    
    concept_curie as congenital_status_concept_curie,
    
    concept_display as congenital_status_concept_display,
    
    concept_definition as congenital_status_concept_definition,
    
    vocabulary_prefix as congenital_status_vocabulary_prefix,
    
    fhir_system as congenital_status_fhir_system,
    
    concept_uri_or_curie as congenital_status_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//congenital_status'
),

dbgap_submission_mappings as (
  select
    source_text::text as dbgap_submission,
    mapped_code::text as dbgap_submission_mapped_code,
    
    concept_curie as dbgap_submission_concept_curie,
    
    concept_display as dbgap_submission_concept_display,
    
    concept_definition as dbgap_submission_concept_definition,
    
    vocabulary_prefix as dbgap_submission_vocabulary_prefix,
    
    fhir_system as dbgap_submission_fhir_system,
    
    concept_uri_or_curie as dbgap_submission_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//dbgap_submission'
),

multiple_datasets_mappings as (
  select
    source_text::text as multiple_datasets,
    mapped_code::text as multiple_datasets_mapped_code,
    
    concept_curie as multiple_datasets_concept_curie,
    
    concept_display as multiple_datasets_concept_display,
    
    concept_definition as multiple_datasets_concept_definition,
    
    vocabulary_prefix as multiple_datasets_vocabulary_prefix,
    
    fhir_system as multiple_datasets_fhir_system,
    
    concept_uri_or_curie as multiple_datasets_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//multiple_datasets'
),

proband_relationship_mappings as (
  select
    source_text::text as proband_relationship,
    mapped_code::text as proband_relationship_mapped_code,
    
    concept_curie as proband_relationship_concept_curie,
    
    concept_display as proband_relationship_concept_display,
    
    concept_definition as proband_relationship_concept_definition,
    
    vocabulary_prefix as proband_relationship_vocabulary_prefix,
    
    fhir_system as proband_relationship_fhir_system,
    
    concept_uri_or_curie as proband_relationship_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//proband_relationship'
),

sex_mappings as (
  select
    source_text::text as sex,
    mapped_code::text as sex_mapped_code,
    
    concept_curie as sex_concept_curie,
    
    concept_display as sex_concept_display,
    
    concept_definition as sex_concept_definition,
    
    vocabulary_prefix as sex_vocabulary_prefix,
    
    fhir_system as sex_fhir_system,
    
    concept_uri_or_curie as sex_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//sex'
),

phenotype_description_mappings as (
  select
    source_text::text as phenotype_description,
    mapped_code::text as phenotype_description_mapped_code,
    
    concept_curie as phenotype_description_concept_curie,
    
    concept_display as phenotype_description_concept_display,
    
    concept_definition as phenotype_description_concept_definition,
    
    vocabulary_prefix as phenotype_description_vocabulary_prefix,
    
    fhir_system as phenotype_description_fhir_system,
    
    concept_uri_or_curie as phenotype_description_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//phenotype_description'
),

solve_state_mappings as (
  select
    source_text::text as solve_state,
    mapped_code::text as solve_state_mapped_code,
    
    concept_curie as solve_state_concept_curie,
    
    concept_display as solve_state_concept_display,
    
    concept_definition as solve_state_concept_definition,
    
    vocabulary_prefix as solve_state_vocabulary_prefix,
    
    fhir_system as solve_state_fhir_system,
    
    concept_uri_or_curie as solve_state_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//solve_state'
)


select -- join the annotations
  base.*,
  subject_type.concept_curie as subject_type_concept_curie,
  organism_type.concept_curie as organism_type_concept_curie,
  organism_type.concept_uri_or_curie as organism_type_concept_uri_or_curie,
  
  affected_status_mapped_code,
  
  affected_status_concept_curie,
  
  affected_status_concept_display,
  
  affected_status_concept_definition,
  
  affected_status_vocabulary_prefix,
  
  affected_status_fhir_system,
  
  affected_status_concept_uri_or_curie,
  
  
  ancestry_mapped_code,
  
  ancestry_concept_curie,
  
  ancestry_concept_display,
  
  ancestry_concept_definition,
  
  ancestry_vocabulary_prefix,
  
  ancestry_fhir_system,
  
  ancestry_concept_uri_or_curie,
  
  
  congenital_status_mapped_code,
  
  congenital_status_concept_curie,
  
  congenital_status_concept_display,
  
  congenital_status_concept_definition,
  
  congenital_status_vocabulary_prefix,
  
  congenital_status_fhir_system,
  
  congenital_status_concept_uri_or_curie,
  
  
  dbgap_submission_mapped_code,
  
  dbgap_submission_concept_curie,
  
  dbgap_submission_concept_display,
  
  dbgap_submission_concept_definition,
  
  dbgap_submission_vocabulary_prefix,
  
  dbgap_submission_fhir_system,
  
  dbgap_submission_concept_uri_or_curie,
  
  
  multiple_datasets_mapped_code,
  
  multiple_datasets_concept_curie,
  
  multiple_datasets_concept_display,
  
  multiple_datasets_concept_definition,
  
  multiple_datasets_vocabulary_prefix,
  
  multiple_datasets_fhir_system,
  
  multiple_datasets_concept_uri_or_curie,
  
  
  proband_relationship_mapped_code,
  
  proband_relationship_concept_curie,
  
  proband_relationship_concept_display,
  
  proband_relationship_concept_definition,
  
  proband_relationship_vocabulary_prefix,
  
  proband_relationship_fhir_system,
  
  proband_relationship_concept_uri_or_curie,
  
  
  sex_mapped_code,
  
  sex_concept_curie,
  
  sex_concept_display,
  
  sex_concept_definition,
  
  sex_vocabulary_prefix,
  
  sex_fhir_system,
  
  sex_concept_uri_or_curie,
  
  
  phenotype_description_mapped_code,
  
  phenotype_description_concept_curie,
  
  phenotype_description_concept_display,
  
  phenotype_description_concept_definition,
  
  phenotype_description_vocabulary_prefix,
  
  phenotype_description_fhir_system,
  
  phenotype_description_concept_uri_or_curie,
  
  
  solve_state_mapped_code,
  
  solve_state_concept_curie,
  
  solve_state_concept_display,
  
  solve_state_concept_definition,
  
  solve_state_vocabulary_prefix,
  
  solve_state_fhir_system,
  
  solve_state_concept_uri_or_curie,
  
  
from base

left join affected_status_mappings
using (affected_status)

left join ancestry_mappings
using (ancestry)

left join congenital_status_mappings
using (congenital_status)

left join dbgap_submission_mappings
using (dbgap_submission)

left join multiple_datasets_mappings
using (multiple_datasets)

left join proband_relationship_mappings
using (proband_relationship)

left join sex_mappings
using (sex)

left join phenotype_description_mappings
using (phenotype_description)

left join solve_state_mappings
using (solve_state)

left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata" as subject_type
  on subject_type.source_concept = base.subject_type_source
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata" as organism_type
  on organism_type.source_concept = base.organism_type_source
    );
    
  