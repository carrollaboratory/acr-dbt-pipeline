{{ config(materialized='table', schema='cser_data') }}

select distinct
'cbfe8c00-7683-4e34-a7ee-23cfb0a1145d'::text as "snapshot_id",
'datarepo-0e626b88'::text as "google_data_project",
'ANVIL_CSER_SouthSeq_GRU_20221208_ANV5_202410021513'::text as "snapshot_dataset",
NULL::text as "table_id",
NULL::text as "parameterized_query",
{{ generate_global_id(prefix='ds',descriptor=['dbgap_study_id'], study_id='cser') }}::text as "id"
from {{ ref('cser_stg_subject') }} as subject