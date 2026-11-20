with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWash_DS_EP_20250219_ANV5_202502201854/sequencing-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sequencing_id" as "sequencing_id",
  "raw"."alignment_method" as "alignment_method",
  "raw"."analyte_type" as "analyte_type",
  "raw"."data_processing_pipeline" as "data_processing_pipeline",
  "raw"."date_data_generation" as "date_data_generation",
  "raw"."exome_capture_platform" as "exome_capture_platform",
  "raw"."ingest_provenance" as "ingest_provenance",
  "raw"."library_prep_kit_method" as "library_prep_kit_method",
  "raw"."reference_genome_build" as "reference_genome_build",
  "raw"."sample_id" as "sample_id",
  "raw"."sequencing_assay" as "sequencing_assay",
  "raw"."sequencing_id_fileref" as "sequencing_id_fileref",
  "raw"."capture_region_bed_file" as "capture_region_bed_file",
  cast('cmg_uwash_ds_ep' as varchar) as source_snapshot,
  cast('f71051be-17e3-42bf-b534-5af0e3740937' as varchar) as source_snapshot_id
from raw