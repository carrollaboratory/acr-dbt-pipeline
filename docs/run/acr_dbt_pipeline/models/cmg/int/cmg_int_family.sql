
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_family__dbt_tmp"
  
    
    as (
      with base as (
select
  f."datarepo_row_id",
  f."family_id",
  f."consanguinity",
  f."ingest_provenance",
  f."source_snapshot",
  f."source_snapshot_id",
  f."family_history",
  f."pedigree_detail",
  f."pedigree_image",
  f."consanguinity_detail",
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
  'fy' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(family_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text  as family_gid,
  'family_id:fy-[' || coalesce(nullif(replace(regexp_replace(trim(cast(family_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as family_id_descriptor
from "acr_dbt_pipeline"."main_cmg"."cmg_main_family" f
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset" ad
using(source_snapshot_id)
),

consanguinity_mappings as (
  select
    source_text::text as consanguinity,
    mapped_code::text as consanguinity_mapped_code,
    
    concept_curie as consanguinity_concept_curie,
    
    concept_display as consanguinity_concept_display,
    
    concept_definition as consanguinity_concept_definition,
    
    vocabulary_prefix as consanguinity_vocabulary_prefix,
    
    fhir_system as consanguinity_fhir_system,
    
    concept_uri_or_curie as consanguinity_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//consanguinity'
),

family_history_mappings as (
  select
    source_text::text as family_history,
    mapped_code::text as family_history_mapped_code,
    
    concept_curie as family_history_concept_curie,
    
    concept_display as family_history_concept_display,
    
    concept_definition as family_history_concept_definition,
    
    vocabulary_prefix as family_history_vocabulary_prefix,
    
    fhir_system as family_history_fhir_system,
    
    concept_uri_or_curie as family_history_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//family_history'
)

select -- join the annotations
    base.*,
    
    consanguinity_mapped_code,
    
    consanguinity_concept_curie,
    
    consanguinity_concept_display,
    
    consanguinity_concept_definition,
    
    consanguinity_vocabulary_prefix,
    
    consanguinity_fhir_system,
    
    consanguinity_concept_uri_or_curie,
    
    
    family_history_mapped_code,
    
    family_history_concept_curie,
    
    family_history_concept_display,
    
    family_history_concept_definition,
    
    family_history_vocabulary_prefix,
    
    family_history_fhir_system,
    
    family_history_concept_uri_or_curie,
    
    
  from base
  
  left join consanguinity_mappings
  using (consanguinity)
  
  left join family_history_mappings
  using (family_history)
  
    );
    
  