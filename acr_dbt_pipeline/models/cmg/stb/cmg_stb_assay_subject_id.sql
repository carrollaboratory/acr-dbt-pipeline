select distinct
  assay_gid::text as "assay_assay_id",
  subject_gid::text as "subject_id_subject_id"
from {{ ref('cmg_int_sequencing') }} seq
where sequencing_id is not null
and subject_id is not null
