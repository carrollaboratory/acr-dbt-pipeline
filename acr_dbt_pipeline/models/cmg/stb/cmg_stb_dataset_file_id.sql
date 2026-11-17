select distinct
    ad.dataset_gid::text as "dataset_dataset_id",
    fi.file_gid::text as "file_id_file_id"
from {{ ref('cmg_int_file_inventory') }} fi
inner join {{ ref('cmg_int_anvil_dataset') }} ad
using (source_snapshot_id)
where fi.file_id is not null
