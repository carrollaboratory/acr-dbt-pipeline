
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_deprecatedconcept__dbt_tmp" as (
    select
    id::integer as "id",
    concept_curie::text as "concept_curie",
    deprecation_type::text as "deprecation_type",
    replacement_curie::text as "replacement_curie"
  );
