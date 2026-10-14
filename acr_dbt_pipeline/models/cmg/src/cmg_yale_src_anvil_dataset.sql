{%- set raw_path = tdr_snapshot_path('cmg_yale_gru', 'anvil_dataset') -%}
select
  {{ normalize_parquet_columns(raw_path) }},
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast('{{ tdr_snapshot_id('cmg_yale_gru') }}' as varchar) as source_snapshot_id
from read_parquet('{{ raw_path | replace("'", "''") }}')
