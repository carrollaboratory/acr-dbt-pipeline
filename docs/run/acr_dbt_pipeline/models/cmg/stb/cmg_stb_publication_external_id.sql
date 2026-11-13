
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_publication_external_id__dbt_tmp" as (
    select
    publication_id::integer as "publication_id",
    external_id::text as "external_id"
  );
