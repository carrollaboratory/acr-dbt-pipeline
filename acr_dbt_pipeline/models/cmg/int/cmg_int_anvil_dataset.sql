with supplement_consent_data as (
select
c.*,
replace(snapshot_url,'https://data.terra.bio/snapshots/','') as source_snapshot_id,
from {{ ref("consent_mapping_datasets") }} c
where institution in ('Yale','UWash')
)

select
  source_snapshot_id::text as source_snapshot_id,
  source_snapshot::text as source_snapshot, 
  registered_identifier::text as registered_identifier,
  sup.consent_group::text as consent_group
from  {{ ref("cmg_main_anvil_dataset") }} ad
left join supplement_consent_data as sup
using (source_snapshot_id)

