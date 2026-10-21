{%- set source = ref('cmg_main_anvil_dataset') -%}
select
  {{ clean_text_columns(source, exclude=['source_snapshot', 'source_snapshot_id']) }}
from {{ source }}
