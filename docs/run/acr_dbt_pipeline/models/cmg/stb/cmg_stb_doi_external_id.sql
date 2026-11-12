
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_doi_external_id__dbt_tmp" as (
    select
    doi_do_id::text as "doi_do_id",
    external_id::text as "external_id"
  );
