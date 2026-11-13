select distinct
  assay_gid::text as "assay_assay_id",
  sample_gid::text as "sample_id_sample_id"
from {{ ref('cmg_int_sequencing') }}
where sequencing_id is not null
and sample_id is not null
