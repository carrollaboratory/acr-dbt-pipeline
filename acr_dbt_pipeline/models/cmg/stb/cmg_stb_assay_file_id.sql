select distinct
    assay_gid::text as "assay_assay_id",
    file_gid::text as "file_id_file_id"
from {{ ref('cmg_int_file_inventory') }}
where file_id is not null
and sequencing_id is not null
