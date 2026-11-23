
    

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
  mapped_code::text as analyte_type_mapped_code
  from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
  where source_system = 'https://anvilproject.org//analyte_type' -- none as of 11/2026
),
sequencing_assay_mappings as (
  select 
  source_text::text as sequencing_assay,
  mapped_code::text as sequencing_assay_mapped_code
  from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
  where source_system = 'https://anvilproject.org//sequencing_assay' -- none as of 11/2026
),
functional_equivalence_standard_mappings as (
  select 
  source_text::text as functional_equivalence_standard,
  mapped_code::text as functional_equivalence_standard_mapped_code
  from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
  where source_system = 'https://anvilproject.org//functional_equivalence_standard' -- none as of 11/2026
  )
  
select -- join the annotations
  base.*
from base
left join analyte_type_mappings
using (analyte_type)
left join sequencing_assay_mappings
using (sequencing_assay)
left join functional_equivalence_standard_mappings
using (functional_equivalence_standard)
    );
    
  