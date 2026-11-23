
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_aliquot__dbt_tmp"
  
    
    as (
      

select
  null::text as "aliquot_id",
  null::text as "sample_id",
  null::text as "availability_status",
  null::text as "quantity_number",
  null::text as "quantity_unit",
  null::text as "concentration_number",
  null::text as "concentration_unit",
  null::text as "access_policy_id",
  null::text as "study_id"
where 1 = 0
    );
    
  