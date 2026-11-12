
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample_external_id__dbt_tmp" as (
    select distinct
    sample_gid::text as "sample_sample_id",
    sample_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample"
  );
