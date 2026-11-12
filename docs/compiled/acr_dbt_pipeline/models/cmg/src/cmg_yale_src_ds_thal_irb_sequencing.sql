with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_THAL_IRB_20240113_ANV5_202410011814/sequencing-*.parquet')
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
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_thal_irb' as varchar) as source_snapshot,
  cast('c68d1d19-aac9-4042-ab62-5f40837fe10d' as varchar) as source_snapshot_id
from raw