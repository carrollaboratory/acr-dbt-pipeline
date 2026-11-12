
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_assay_subject_id__dbt_tmp" as (
    select distinct
  assay_gid::text as "assay_assay_id",
  subject_gid::text as "subject_id_subject_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing" seq
where sequencing_assay is not null
and sample_id is not null
  );
