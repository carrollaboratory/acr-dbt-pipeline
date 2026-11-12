
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_external_id__dbt_tmp" as (
    select distinct
  assay_gid::text as "assay_assay_id",
  sequencing_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing"
where sequencing_id is not null
  );
