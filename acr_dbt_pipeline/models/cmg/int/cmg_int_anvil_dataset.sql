with supplement_consent_data as (
select
c.*,
replace(snapshot_url,'https://data.terra.bio/snapshots/','') as source_snapshot_url_id
from {{ source('enrichment', 'consent_mapping_datasets') }} c
where institution in ('Yale','UWash')
),

dataset as (
select
  ad.source_snapshot_id::text as source_snapshot_id,
  ad.source_snapshot::text as source_snapshot,
  array_to_string(ad.registered_identifier, ',')::text as registered_identifier,
  sup.consent_group::text as consent_group,
  ad.dataset_id::text as dataset_id,
  ad.title::text as dataset_title,
  sup.data_use_permission_duo_code::text as data_use_permission_duo_code,
  sup.data_use_modifier_duo_codes::text as data_use_modifier_duo_codes,
  sup.disease_limitation::text as disease_limitation
from  {{ ref("cmg_main_anvil_dataset") }} as ad
left join supplement_consent_data as sup
on source_snapshot_id = source_snapshot_url_id
),
identified_dataset as (
select
  source_snapshot_id,
  source_snapshot,
  registered_identifier,
  consent_group,
  {{ generate_md5_global_id(prefix='st', descriptor=["registered_identifier"]) }}::text  as study_gid,
  {{ generate_md5_global_id(prefix='co', descriptor=["registered_identifier", "consent_group"]) }}::text  as access_policy_gid,
  {{ generate_descriptor_for_analysis(prefix='st', descriptor=["registered_identifier"]) }}::text as study_id_descriptor,
  {{ generate_descriptor_for_analysis(prefix='co', descriptor=["registered_identifier", "consent_group"]) }}::text as access_policy_descriptor,
  {{ generate_md5_global_id(prefix='ds', descriptor=["source_snapshot_id"]) }}::text  as dataset_gid,
  {{ generate_descriptor_for_analysis(prefix='ds', descriptor=["source_snapshot_id"]) }}::text as dataset_id_descriptor,
  dataset_id,
  dataset_title,
  data_use_permission_duo_code,
  data_use_modifier_duo_codes,
  disease_limitation
from dataset
)
select
  dataset.*,
  permission.concept_curie as data_use_permission_concept_curie,
  permission.concept_display as data_use_permission_concept_display,
  permission.concept_definition as data_use_permission_concept_definition,
  permission.vocabulary_prefix as data_use_permission_vocabulary_prefix,
  permission.fhir_system as data_use_permission_fhir_system,
  modifier.concept_curie as data_use_modifier_concept_curie,
  modifier.concept_display as data_use_modifier_concept_display,
  modifier.concept_definition as data_use_modifier_concept_definition,
  modifier.vocabulary_prefix as data_use_modifier_vocabulary_prefix,
  modifier.fhir_system as data_use_modifier_fhir_system
from identified_dataset as dataset
left join {{ ref('cmg_int_concept_metadata') }} as permission
  on permission.source_concept = dataset.data_use_permission_duo_code
left join {{ ref('cmg_int_concept_metadata') }} as modifier
  on modifier.source_concept = dataset.data_use_modifier_duo_codes
