with supplement_consent_data as (
select
{{ dbt_utils.star(ref("consent_mapping_datasets"), relation_alias='c') }},
replace(snapshot_url,'https://data.terra.bio/snapshots/','') as source_snapshot_url_id
from {{ ref("consent_mapping_datasets") }} c
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
)

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
