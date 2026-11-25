select distinct
    study_gid::text as "study_study_id",
    {{ normalize_curie('registered_identifier', default_prefix='dbgap', alias_column='synonym') }}::text as "external_id"
from {{ ref('cmg_int_anvil_dataset') }}
where registered_identifier is not null
