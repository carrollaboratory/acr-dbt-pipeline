
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_conceptrelationship__dbt_tmp" as (
    select
    id::integer as "id",
    concept_curie::text as "concept_curie",
    target_concept_curie::text as "target_concept_curie",
    relationship_curie::text as "relationship_curie"
  );
