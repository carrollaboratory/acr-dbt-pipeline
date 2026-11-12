
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_processing__dbt_tmp" as (
    select
    sample_sample_id::text as "sample_sample_id",
    processing::text as "processing"
  );
