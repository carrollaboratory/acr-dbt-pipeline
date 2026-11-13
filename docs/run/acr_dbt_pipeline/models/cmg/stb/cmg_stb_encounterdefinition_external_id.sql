
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounterdefinition_external_id__dbt_tmp" as (
    select
    encounterdefinition_encounter_definition_id::text as "encounterdefinition_encounter_definition_id",
    external_id::text as "external_id"
  );
