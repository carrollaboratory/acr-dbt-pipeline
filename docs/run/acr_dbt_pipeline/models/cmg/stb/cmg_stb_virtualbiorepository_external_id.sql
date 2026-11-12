
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_virtualbiorepository_external_id__dbt_tmp" as (
    select
    virtualbiorepository_vbr_id::text as "virtualbiorepository_vbr_id",
    external_id::text as "external_id"
  );
