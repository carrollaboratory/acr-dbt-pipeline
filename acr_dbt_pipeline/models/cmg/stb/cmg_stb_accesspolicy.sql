-- one row per study + consent group
select distinct
    access_policy_gid::text as "access_policy_id",
    {{ normalize_curie('registered_identifier', default_prefix='dbgap', alias_column='synonym') }}::text as "data_use_accession",
    data_use_permission_duo_code::text as "data_use_permission",
    data_use_modifier_duo_codes::text as "data_use_modifier",
    disease_limitation::text as "disease_limitation",
    cast(null as text) as "access_description",
    cast(null as text) as "website"
from {{ ref('cmg_int_anvil_dataset') }}
where access_policy_gid is not null
