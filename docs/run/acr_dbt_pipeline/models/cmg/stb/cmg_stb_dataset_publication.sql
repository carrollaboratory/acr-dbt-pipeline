
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset_publication__dbt_tmp" as (
    select
    dataset_dataset_id::text as "dataset_dataset_id",
    publication_id::integer as "publication_id"
  );
