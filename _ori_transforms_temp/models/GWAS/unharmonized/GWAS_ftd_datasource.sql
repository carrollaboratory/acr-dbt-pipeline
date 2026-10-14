{{ config(materialized='table', schema='GWAS_data') }}

select 
null::text as "snapshot_id",
null::text as "google_data_project",
null::text as "snapshot_dataset",
null::text as "table",
null::text as "parameterized_query",
null::text as "id"
