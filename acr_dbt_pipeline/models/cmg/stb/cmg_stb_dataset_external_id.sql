select distinct
    dataset_gid::text as "dataset_dataset_id",
    snapshot_url::text as "external_id"
from {{ ref('cmg_int_anvil_dataset') }}
where snapshot_url is not null
