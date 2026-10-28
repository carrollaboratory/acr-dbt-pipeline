select distinct
  assay_gid::text as "assay_assay_id",
  sequencing_id::text as "external_id"
from {{ ref('cmg_int_sequencing') }}
where sequencing_id is not null
