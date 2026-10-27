select
  {{ generate_global_id(prefix='co', descriptor=['consent_group']) }}::text as  "access_policy_id",
  {{ normalize_curie(registered_identifier, default_prefix=dbgap) }}::text as "data_use_accession",
    data_use_permission::text as "data_use_permission",
    data_use_modifier::text as "data_use_modifier",
    disease_limitation::text as "disease_limitation",
    access_description::text as "access_description",
    website::text as "website"


with base as (
  select
    -- null::text as access_policy_id, -- Global Id to be generated and joined in the stb model
    a.dbgap::text as data_use_accession,
    -- null::text as data_use_permission,
    d.access_requirements::text as data_use_modifier,
    a.selection_criteria::text as disease_limitation,
    null::text as access_description,
    a.study_website::text as website
    study_code,
    {{ normalize_http_uri('study_website') }} as study_website,
    {{ normalize_curie('dbgap', default_prefix='dbgap') }} as dbgap,
    selection_criteria
  {{ normalize_descriptors(descriptor_cols=['access_policy_hc']) }}::text as access_policy_descriptor,
  access_policy_hc::text as data_use_permission
