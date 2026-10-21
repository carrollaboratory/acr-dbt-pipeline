{#-
  Cleans the unioned anvil_dataset table.

  Every text column is trimmed and its null sentinels are turned into real
  NULLs. source_snapshot and source_snapshot_id are excluded because they are
  pipeline-generated provenance, not source data.
-#}
{%- set source = ref('cmg_main_anvil_dataset') -%}
select
  {{ clean_text_columns(source, exclude=['source_snapshot', 'source_snapshot_id']) }}
from {{ source }}
