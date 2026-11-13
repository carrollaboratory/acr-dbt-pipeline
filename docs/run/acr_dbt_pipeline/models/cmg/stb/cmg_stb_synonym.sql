
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_synonym__dbt_tmp" as (
    select
    id::integer as "id",
    concept_curie::text as "concept_curie",
    display::text as "display",
    display_type::text as "display_type",
    language::text as "language"
  );
