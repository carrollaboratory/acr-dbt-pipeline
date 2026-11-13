
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_sample_id__dbt_tmp" as (
    select
    file_file_id::text as "file_file_id",
    sample_id_sample_id::text as "sample_id_sample_id"
  );
