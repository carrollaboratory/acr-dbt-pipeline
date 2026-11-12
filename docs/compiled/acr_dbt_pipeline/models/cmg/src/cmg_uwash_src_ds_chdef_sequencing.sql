with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_DS_CHDEF_20250224_ANV5_202502241753/sequencing-*.parquet')
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
  cast('cmg_uwash_ds_chdef' as varchar) as source_snapshot,
  cast('10e413c2-729c-4802-a387-6763a7798d8f' as varchar) as source_snapshot_id
from raw