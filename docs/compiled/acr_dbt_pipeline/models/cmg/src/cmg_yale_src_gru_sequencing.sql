with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_GRU_20221020_ANV5_202507091800/sequencing-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."sequencing_id" as "sequencing_id",
  "raw"."alignment_method" as "alignment_method",
  "raw"."analyte_type" as "analyte_type",
  "raw"."data_processing_pipeline" as "data_processing_pipeline",
  "raw"."date_data_generation" as "date_data_generation",
  "raw"."functional_equivalence_standard" as "functional_equivalence_standard",
  "raw"."library_prep_kit_method" as "library_prep_kit_method",
  "raw"."reference_genome_build" as "reference_genome_build",
  "raw"."sample_id" as "sample_id",
  "raw"."seq_filename" as "seq_filename",
  "raw"."sequencing_assay" as "sequencing_assay",
  "raw"."capture_region_bed_file" as "capture_region_bed_file",
  "raw"."exome_capture_platform" as "exome_capture_platform",
  "raw"."ingest_provenance" as "ingest_provenance",
  "raw"."sequencing_id_fileref" as "sequencing_id_fileref",
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast('d3caa579-e6f0-458e-859b-008d89af0b48' as varchar) as source_snapshot_id
from raw