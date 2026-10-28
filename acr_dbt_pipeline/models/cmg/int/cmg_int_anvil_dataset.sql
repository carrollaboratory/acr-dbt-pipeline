
select
  source_snapshot_id,
  source_snapshot,
  registered_identifier,
  consent_group,
--duos_consent_code
from  {{ ref("cmg_main_anvil_dataset")}} ad
