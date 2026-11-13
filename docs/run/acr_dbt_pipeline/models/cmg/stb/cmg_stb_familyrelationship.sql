
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_familyrelationship__dbt_tmp" as (
    select
    family_relationship_id::text as "family_relationship_id",
    family_member_id::text as "family_member_id",
    relation::text as "relation",
    subject_id::text as "subject_id",
    access_policy_id::text as "access_policy_id",
    study_id::text as "study_id"
  );
