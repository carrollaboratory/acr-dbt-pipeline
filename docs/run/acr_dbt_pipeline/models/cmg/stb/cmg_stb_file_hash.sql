
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_hash__dbt_tmp" as (
    select
    file_file_id::text as "file_file_id",
    hash_id::integer as "hash_id"
  );
