select distinct
    file_gid::text as "file_file_id",
    file_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory"
where file_id is not null