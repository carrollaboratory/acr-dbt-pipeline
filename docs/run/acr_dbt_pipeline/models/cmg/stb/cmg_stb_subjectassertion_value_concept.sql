
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_subjectassertion_value_concept__dbt_tmp" as (
    select
    subjectassertion_assertion_id::text as "subjectassertion_assertion_id",
    value_concept_concept_curie::text as "value_concept_concept_curie"
  );
