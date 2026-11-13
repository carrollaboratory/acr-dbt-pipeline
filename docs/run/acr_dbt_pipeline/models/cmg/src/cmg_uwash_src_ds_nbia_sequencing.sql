
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_sequencing__dbt_tmp"
  
    
    as (
      with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/uwash/ANVIL_CMG_UWASH_DS_NBIA_20250206_ANV5_202502201903/sequencing-*.parquet')
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
  "raw"."sequencing_assay" as "sequencing_assay",
  "raw"."sequencing_id_fileref" as "sequencing_id_fileref",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_uwash_ds_nbia' as varchar) as source_snapshot,
  cast('4a815323-5dc1-4a0c-93c0-1c2333345c4d' as varchar) as source_snapshot_id
from raw
    );
    
  