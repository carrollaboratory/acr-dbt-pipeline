
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_investigator_external_id__dbt_tmp" as (
    select
    investigator_id::integer as "investigator_id",
    external_id::text as "external_id"
  );
