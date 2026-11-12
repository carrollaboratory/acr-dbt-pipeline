
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_family_external_id__dbt_tmp" as (
    select distinct
  family_gid::text as "family_family_id",
  family_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_family"
where family_id is not null
  );
