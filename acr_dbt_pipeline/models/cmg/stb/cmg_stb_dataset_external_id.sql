select distinct
    dataset_gid::text as "dataset_dataset_id",
    source_snapshot_id::text as "external_id"
from {{ ref('cmg_int_anvil_dataset') }}
where source_snapshot_id is not null
