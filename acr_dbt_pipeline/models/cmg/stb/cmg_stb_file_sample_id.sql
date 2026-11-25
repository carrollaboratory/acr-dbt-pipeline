select distinct
    file_gid::text as "file_file_id",
    sample_gid::text as "sample_id_sample_id"
from {{ ref('cmg_int_file_inventory') }}
where file_id is not null
and sample_id is not null
