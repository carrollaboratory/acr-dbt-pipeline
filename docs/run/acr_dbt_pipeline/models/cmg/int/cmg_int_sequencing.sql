
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing__dbt_tmp"
  
    
    as (
      with base as (
select
  seq."datarepo_row_id",
  seq."sequencing_id",
  seq."alignment_method",
  seq."analyte_type",
  seq."data_processing_pipeline",
  seq."date_data_generation",
  seq."functional_equivalence_standard",
  seq."library_prep_kit_method",
  seq."reference_genome_build",
  seq."sample_id",
  seq."seq_filename",
  seq."sequencing_assay",
  seq."capture_region_bed_file",
  seq."exome_capture_platform",
  seq."ingest_provenance",
  seq."sequencing_id_fileref",
  seq."source_snapshot",
  seq."source_snapshot_id",
  seq."file_id",
  sa."sample_gid",
  sa."sample_id_descriptor",
  sa."subject_id",
  sa."subject_gid",
  sa."subject_id_descriptor",
  sa."person_gid",
  sa."person_id_descriptor",
  sa."study_gid",
  sa."study_id_descriptor",
  sa."access_policy_gid",
  sa."access_policy_descriptor",
  sa."consent_group",
  sa."sequencing_center",
  'ay' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(seq.sequencing_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(sa.consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as assay_gid,
  'sequencing_id|consent_group:ay-[' || coalesce(nullif(replace(regexp_replace(trim(cast(seq.sequencing_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(sa.consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as assay_id_descriptor
from "acr_dbt_pipeline"."main_cmg"."cmg_main_sequencing" seq
left join (
select distinct
  sample_id,
  source_snapshot_id,
  sample_gid,
  sample_id_descriptor,
  subject_id,
  subject_gid,
  subject_id_descriptor,
  person_gid,
  person_id_descriptor,
  study_gid,
  study_id_descriptor,
  access_policy_gid,
  access_policy_descriptor,
  consent_group,
  sequencing_center
from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample" ) sa
using (sample_id, source_snapshot_id)
),

analyte_type_mappings as (
  select
    source_text::text as analyte_type,
    mapped_code::text as analyte_type_mapped_code,
    
    concept_curie as analyte_type_concept_curie,
    
    concept_display as analyte_type_concept_display,
    
    concept_definition as analyte_type_concept_definition,
    
    vocabulary_prefix as analyte_type_vocabulary_prefix,
    
    fhir_system as analyte_type_fhir_system,
    
    concept_uri_or_curie as analyte_type_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//analyte_type'
),

sequencing_assay_mappings as (
  select
    source_text::text as sequencing_assay,
    mapped_code::text as sequencing_assay_mapped_code,
    
    concept_curie as sequencing_assay_concept_curie,
    
    concept_display as sequencing_assay_concept_display,
    
    concept_definition as sequencing_assay_concept_definition,
    
    vocabulary_prefix as sequencing_assay_vocabulary_prefix,
    
    fhir_system as sequencing_assay_fhir_system,
    
    concept_uri_or_curie as sequencing_assay_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//sequencing_assay'
),

functional_equivalence_standard_mappings as (
  select
    source_text::text as functional_equivalence_standard,
    mapped_code::text as functional_equivalence_standard_mapped_code,
    
    concept_curie as functional_equivalence_standard_concept_curie,
    
    concept_display as functional_equivalence_standard_concept_display,
    
    concept_definition as functional_equivalence_standard_concept_definition,
    
    vocabulary_prefix as functional_equivalence_standard_vocabulary_prefix,
    
    fhir_system as functional_equivalence_standard_fhir_system,
    
    concept_uri_or_curie as functional_equivalence_standard_concept_uri_or_curie
    
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//functional_equivalence_standard'
)

  
select -- join the annotations
  base.*,
  
  analyte_type_mapped_code,
  
  analyte_type_concept_curie,
  
  analyte_type_concept_display,
  
  analyte_type_concept_definition,
  
  analyte_type_vocabulary_prefix,
  
  analyte_type_fhir_system,
  
  analyte_type_concept_uri_or_curie,
  
  
  sequencing_assay_mapped_code,
  
  sequencing_assay_concept_curie,
  
  sequencing_assay_concept_display,
  
  sequencing_assay_concept_definition,
  
  sequencing_assay_vocabulary_prefix,
  
  sequencing_assay_fhir_system,
  
  sequencing_assay_concept_uri_or_curie,
  
  
  functional_equivalence_standard_mapped_code,
  
  functional_equivalence_standard_concept_curie,
  
  functional_equivalence_standard_concept_display,
  
  functional_equivalence_standard_concept_definition,
  
  functional_equivalence_standard_vocabulary_prefix,
  
  functional_equivalence_standard_fhir_system,
  
  functional_equivalence_standard_concept_uri_or_curie,
  
  
from base

left join analyte_type_mappings
using (analyte_type)

left join sequencing_assay_mappings
using (sequencing_assay)

left join functional_equivalence_standard_mappings
using (functional_equivalence_standard)

    );
    
  