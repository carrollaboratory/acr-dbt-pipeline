{{ config(enabled = tdr_snapshot_enabled('cmg_yale_gru')) }}

{% set raw_anvil_dataset = source('cmg_yale_gru', 'anvil_dataset') %}

select
  {{ normalize_source_columns(raw_anvil_dataset) }},
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id('cmg_yale_gru') }}' as varchar) as source_snapshot_id
from {{ raw_anvil_dataset }}
