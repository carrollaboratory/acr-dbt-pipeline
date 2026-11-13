
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_familyrelationship_external_id__dbt_tmp" as (
    select
    familyrelationship_family_relationship_id::text as "familyrelationship_family_relationship_id",
    external_id::text as "external_id"
  );
