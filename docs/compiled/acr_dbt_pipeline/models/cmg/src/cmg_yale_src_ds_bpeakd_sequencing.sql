with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_DS_BPEAKD_20240113_ANV5_202410011754/sequencing-*.parquet')
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
  cast('cmg_yale_ds_bpeakd' as varchar) as source_snapshot,
  cast('9e210e43-61b5-4a85-8d1a-0abc111f60db' as varchar) as source_snapshot_id
from raw