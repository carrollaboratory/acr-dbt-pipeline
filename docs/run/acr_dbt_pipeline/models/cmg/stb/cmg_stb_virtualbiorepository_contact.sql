
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_virtualbiorepository_contact__dbt_tmp" as (
    select
    virtualbiorepository_vbr_id::text as "virtualbiorepository_vbr_id",
    contact_id::integer as "contact_id"
  );
