
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_external_id__dbt_tmp" as (
    select
    dataset_dataset_id::text as "dataset_dataset_id",
    external_id::text as "external_id"
  );
