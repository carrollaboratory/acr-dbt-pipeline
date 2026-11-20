select distinct
    assay_gid::text as "assay_id",
    sequencing_assay::text as "assay_type",
    cast(null as text) as "assay_source",
    cast(null as text) as "activity_definition_id",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_sequencing') }}
where sequencing_id is not null
