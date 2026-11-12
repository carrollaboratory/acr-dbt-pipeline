select distinct
    subject_gid::text as "subject_subject_id",
    subject_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"