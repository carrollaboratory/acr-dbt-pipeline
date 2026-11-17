select distinct
    dataset_gid::text as "dataset_id",
    dataset_title::text as "name",
    cast(null as text) as "description",
    cast(null as text) as "do_id",
    cast(null as text) as "data_collection_start",
    cast(null as text) as "data_collection_end",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_anvil_dataset') }}
where source_snapshot_id is not null
