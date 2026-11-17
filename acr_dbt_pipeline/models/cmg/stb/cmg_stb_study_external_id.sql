select distinct
    study_gid::text as "study_study_id",
    registered_identifier::text as "external_id"
from {{ ref('cmg_int_anvil_dataset') }}
where registered_identifier is not null
