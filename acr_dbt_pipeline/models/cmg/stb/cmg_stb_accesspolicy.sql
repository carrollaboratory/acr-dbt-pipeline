select
  {{ generate_global_id(prefix='co', descriptor=['consent_group']) }}::text as  "access_policy_id",
  --{{ normalize_curie(registered_identifier, default_prefix=dbgap) }}::text as "data_use_accession",
    data_use_permission::text as "data_use_permission",
    data_use_modifier::text as "data_use_modifier",
    disease_limitation::text as "disease_limitation",
    access_description::text as "access_description",
    website::text as "website"

