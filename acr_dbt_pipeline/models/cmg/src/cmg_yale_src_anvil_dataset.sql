{% set raw_anvil_dataset = source('cmg_yale_gru', 'anvil_dataset') %}

select
  {{ normalize_source_columns(raw_anvil_dataset) }},
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast(
    '{{ env_var(var("tdr_snapshots")["cmg_yale_gru"]["snapshot_id_env_var"]) }}'
    as varchar
  ) as source_snapshot_id
from {{ raw_anvil_dataset }}
