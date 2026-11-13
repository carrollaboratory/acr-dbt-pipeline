
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_file_subject_id__dbt_tmp" as (
    select
    file_file_id::text as "file_file_id",
    subject_id_subject_id::text as "subject_id_subject_id"
  );
