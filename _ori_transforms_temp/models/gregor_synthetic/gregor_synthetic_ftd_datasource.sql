{{ config(materialized='table', schema='gregor_synthetic_data') }}

select 
NULL::text as "snapshot_id",
NULL::text as "google_data_project",
NULL::text as "snapshot_dataset",
NULL::text as "table_id",
NULL::text as "parameterized_query",
NULL::text as "id"