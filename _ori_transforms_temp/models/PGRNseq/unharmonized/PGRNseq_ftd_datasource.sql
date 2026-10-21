{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "snapshot_id",
NULL::text as "google_data_project",
NULL::text as "snapshot_dataset",
NULL::text as "table",
NULL::text as "parameterized_query",
NULL::text as "id"