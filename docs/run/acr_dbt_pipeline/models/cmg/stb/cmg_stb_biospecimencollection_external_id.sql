
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_biospecimencollection_external_id__dbt_tmp" as (
    select
    biospecimencollection_biospecimen_collection_id::text as "biospecimencollection_biospecimen_collection_id",
    external_id::text as "external_id"
  );
