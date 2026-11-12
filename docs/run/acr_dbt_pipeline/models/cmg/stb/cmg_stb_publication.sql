
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_publication__dbt_tmp" as (
    select
    id::integer as "id",
    bibliographic_reference::text as "bibliographic_reference",
    website::text as "website",
    access_policy_id::text as "access_policy_id",
    study_id::text as "study_id"
  );
