
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_activitydefinition_external_id__dbt_tmp" as (
    select
    activitydefinition_activity_definition_id::text as "activitydefinition_activity_definition_id",
    external_id::text as "external_id"
  );
