
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_person_external_id__dbt_tmp" as (
    select distinct
    person_id_gid::text as "person_person_id",
    person_id ::text as "external_id" --todo
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
  );
