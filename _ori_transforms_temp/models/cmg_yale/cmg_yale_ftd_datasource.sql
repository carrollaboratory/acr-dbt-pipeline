{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  NULL::text as "snapshot_id",
  NULL::text as "google_data_project",
  NULL::text as "snapshot_dataset",
  NULL::text as "table_id",
  NULL::text as "parameterized_query",
--   { { generate_global_id(prefix='',descriptor=[''], study_id='cmg_yale') }}::text as "id"
  NULL::text as "id"