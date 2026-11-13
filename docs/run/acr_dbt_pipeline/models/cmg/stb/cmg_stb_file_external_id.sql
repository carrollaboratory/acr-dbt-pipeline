
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_external_id__dbt_tmp" as (
    select
    file_file_id::text as "file_file_id",
    external_id::text as "external_id"
  );
