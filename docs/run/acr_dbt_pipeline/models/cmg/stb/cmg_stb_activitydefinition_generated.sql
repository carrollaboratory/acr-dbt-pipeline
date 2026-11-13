
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_activitydefinition_generated__dbt_tmp" as (
    select
    activity_definition_id::text as "activity_definition_id",
    name::text as "name",
    description::text as "description",
    access_policy_id::text as "access_policy_id",
    study_id::text as "study_id"
  );
