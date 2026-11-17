select distinct
    file_gid::text as "file_file_id",
    file_id::text as "external_id"
from {{ ref('cmg_int_file_inventory') }}
where file_id is not null
