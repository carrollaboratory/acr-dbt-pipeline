with raw as (
  select *
  from read_parquet('/home/rstudio/pipelines/data/yale/ANVIL_CMG_YALE_DS_MC_20221026_ANV5_202409302315/family-*.parquet')
)
select
  "raw"."datarepo_row_id" as "datarepo_row_id",
  "raw"."family_id" as "family_id",
  "raw"."consanguinity" as "consanguinity",
  "raw"."ingest_provenance" as "ingest_provenance",
  cast('cmg_yale_ds_mc' as varchar) as source_snapshot,
  cast('c720c477-dfe2-45e0-805f-94ed11d006b4' as varchar) as source_snapshot_id
from raw