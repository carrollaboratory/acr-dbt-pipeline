
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_person_subject_id__dbt_tmp" as (
    select
    person_person_id::text as "person_person_id",
    subject_id_subject_id::text as "subject_id_subject_id"
  );
