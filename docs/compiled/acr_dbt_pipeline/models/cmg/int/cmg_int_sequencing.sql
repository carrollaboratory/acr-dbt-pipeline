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
  'ay' || '_' || md5(cast(coalesce(seq.sequencing_id, '') as text) || '|' || cast(coalesce(sa.consent_group, '') as text))::text as assay_gid,
  concat('sequencing_id|consent_group:ay-[', seq."sequencing_id", '|', sa."consent_group", ']') AS assay_id_descriptor
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
)
  
select -- join the annotations
  base.*
from base