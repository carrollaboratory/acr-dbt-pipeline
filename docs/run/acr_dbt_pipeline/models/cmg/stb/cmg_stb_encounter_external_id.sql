
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounter_external_id__dbt_tmp" as (
    select
    encounter_encounter_id::text as "encounter_encounter_id",
    external_id::text as "external_id"
  );
