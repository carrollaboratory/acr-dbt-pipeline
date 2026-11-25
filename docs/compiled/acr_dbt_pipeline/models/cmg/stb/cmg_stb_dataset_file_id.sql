select distinct
    ad.dataset_gid::text as "dataset_dataset_id",
    fi.file_gid::text as "file_id_file_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory" fi
inner join "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset" ad
using (source_snapshot_id)
where fi.file_id is not null