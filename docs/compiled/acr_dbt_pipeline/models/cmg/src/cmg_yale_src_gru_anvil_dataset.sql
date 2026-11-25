with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_Yale_GRU_20221020_ANV5_202507091800/anvil_dataset-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."dataset_id" as "dataset_id",
  "raw"."consent_group" as "consent_group",
  "raw"."data_use_permission" as "data_use_permission",
  "raw"."owner" as "owner",
  "raw"."principal_investigator" as "principal_investigator",
  "raw"."registered_identifier" as "registered_identifier",
  "raw"."title" as "title",
  "raw"."data_modality" as "data_modality",
  "raw"."source_datarepo_row_ids" as "source_datarepo_row_ids",
  cast('cmg_yale_gru' as varchar) as source_snapshot,
  cast('d3caa579-e6f0-458e-859b-008d89af0b48' as varchar) as source_snapshot_id
from raw