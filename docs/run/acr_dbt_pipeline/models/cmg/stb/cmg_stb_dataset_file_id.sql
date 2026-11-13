
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_file_id__dbt_tmp" as (
    select
    dataset_dataset_id::text as "dataset_dataset_id",
    file_id_file_id::text as "file_id_file_id"
  );
