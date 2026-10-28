select distinct
    sample_gid::text as "sample_id",
    cast(null as text) as "biospecimen_collection_id",
    cast(null as text) as "parent_sample_id",
    sample_source::text as "sample_type",
    subject_gid::text as "subject_id",
    cast(null as text) as "availability_status",
    cast(null as text) as "quantity_number",
    cast(null as text) as "quantity_unit",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from {{ ref('cmg_int_sample') }}