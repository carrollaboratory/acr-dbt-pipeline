select distinct
    sample_gid::text as "sample_sample_id",
    sample_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample"