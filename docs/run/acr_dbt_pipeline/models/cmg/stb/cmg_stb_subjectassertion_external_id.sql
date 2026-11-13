
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_subjectassertion_external_id__dbt_tmp" as (
    select
    subjectassertion_assertion_id::text as "subjectassertion_assertion_id",
    external_id::text as "external_id"
  );
