
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_biospecimencollection__dbt_tmp"
  
    
    as (
      

select
  null::text as "biospecimen_collection_id",
  null::text as "age_at_collection",
  null::text as "method",
  null::text as "site",
  null::text as "spatial_qualifier",
  null::text as "laterality",
  null::text as "encounter_id",
  null::text as "access_policy_id",
  null::text as "study_id"
where 1 = 0
    );
    
  