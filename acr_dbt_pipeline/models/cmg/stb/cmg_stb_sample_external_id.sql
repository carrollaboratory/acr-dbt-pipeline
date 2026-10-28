select distinct
    sample_gid::text as "sample_sample_id",
    sample_id::text as "external_id"
from {{ ref('cmg_int_sample') }}
