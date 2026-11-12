
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_file_id__dbt_tmp" as (
    select
    assay_assay_id::text as "assay_assay_id",
    file_id_file_id::text as "file_id_file_id"
  );
