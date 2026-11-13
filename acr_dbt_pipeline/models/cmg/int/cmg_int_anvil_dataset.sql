with supplement_consent_data as (
select
c.*,
replace(snapshot_url,'https://data.terra.bio/snapshots/','') as source_snapshot_url_id
from {{ ref("consent_mapping_datasets") }} c
where institution in ('Yale','UWash')
)

select
  ad.source_snapshot_id::text as source_snapshot_id,
  ad.source_snapshot::text as source_snapshot, 
  ad.registered_identifier::text as registered_identifier,
  sup.consent_group::text as consent_group,
  {{ generate_global_id(prefix='st', descriptor=["registered_identifier"]) }}::text  as study_gid,
  {{ generate_global_id(prefix='co', descriptor=["consent_group"]) }}::text  as access_policy_gid,
  concat('registered_identifier:st-[', ad.registered_identifier::text, ']') AS study_id_descriptor,
  concat('consent_group:co-[', sup.consent_group::text, ']') AS access_policy_descriptor
from  {{ ref("cmg_main_anvil_dataset") }} as ad
left join supplement_consent_data as sup
on source_snapshot_id = source_snapshot_url_id

