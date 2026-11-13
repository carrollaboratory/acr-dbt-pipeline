
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounterdefinition_activity_definition_id__dbt_tmp" as (
    select
    encounterdefinition_encounter_definition_id::text as "encounterdefinition_encounter_definition_id",
    activity_definition_id_activity_definition_id::text as "activity_definition_id_activity_definition_id"
  );
