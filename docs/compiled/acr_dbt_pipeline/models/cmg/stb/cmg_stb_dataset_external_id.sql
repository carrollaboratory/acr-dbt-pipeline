select distinct
    dataset_gid::text as "dataset_dataset_id",
    source_snapshot_id::text as "external_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset"
where source_snapshot_id is not null