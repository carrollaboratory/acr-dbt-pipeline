
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_record_external_id__dbt_tmp" as (
    select
    record_id::integer as "record_id",
    external_id::text as "external_id"
  );
