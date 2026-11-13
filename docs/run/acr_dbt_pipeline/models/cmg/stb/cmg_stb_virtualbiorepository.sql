
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_virtualbiorepository__dbt_tmp" as (
    select
    vbr_id::text as "vbr_id",
    name::text as "name",
    institution::text as "institution",
    website::text as "website",
    vbr_readme::text as "vbr_readme",
    access_policy_id::text as "access_policy_id",
    study_id::text as "study_id"
  );
