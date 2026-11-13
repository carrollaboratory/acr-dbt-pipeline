
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_investigator__dbt_tmp" as (
    select
    id::integer as "id",
    name::text as "name",
    institution::text as "institution",
    investigator_title::text as "investigator_title",
    email::text as "email",
    access_policy_id::text as "access_policy_id",
    study_id::text as "study_id"
  );
