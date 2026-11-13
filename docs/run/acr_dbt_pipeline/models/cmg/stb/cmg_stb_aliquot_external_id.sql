
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_aliquot_external_id__dbt_tmp" as (
    select
    aliquot_aliquot_id::text as "aliquot_aliquot_id",
    external_id::text as "external_id"
  );
