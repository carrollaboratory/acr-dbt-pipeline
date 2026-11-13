
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_familymembership_external_id__dbt_tmp" as (
    select
    familymembership_family_membership_id::text as "familymembership_family_membership_id",
    external_id::text as "external_id"
  );
