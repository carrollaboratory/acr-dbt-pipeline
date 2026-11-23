select distinct
    file_gid::text as "file_file_id",
    subject_gid::text as "subject_id_subject_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory"
where file_id is not null
and subject_id is not null