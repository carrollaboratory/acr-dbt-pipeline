
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_storage_method__dbt_tmp" as (
    select
    sample_sample_id::text as "sample_sample_id",
    storage_method::text as "storage_method"
  );
