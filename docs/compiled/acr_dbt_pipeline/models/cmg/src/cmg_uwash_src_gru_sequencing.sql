with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_GRU_20250224_ANV5_202502241706/sequencing-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sequencing_id" as "sequencing_id",
  "raw"."alignment_method" as "alignment_method",
  "raw"."analyte_type" as "analyte_type",
  "raw"."data_processing_pipeline" as "data_processing_pipeline",
  "raw"."date_data_generation" as "date_data_generation",
  "raw"."exome_capture_platform" as "exome_capture_platform",
  "raw"."library_prep_kit_method" as "library_prep_kit_method",
  "raw"."reference_genome_build" as "reference_genome_build",
  "raw"."sample_id" as "sample_id",
  "raw"."seq_filename" as "seq_filename",
  "raw"."sequencing_assay" as "sequencing_assay",
  "raw"."capture_region_bed_file" as "capture_region_bed_file",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_gru' as varchar) as source_snapshot,
  cast('db0c9cff-f3f9-4315-addb-6b6c9088b124' as varchar) as source_snapshot_id
from raw