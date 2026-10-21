{{ config(materialized='table', schema='cser_data') }}

select 
NULL::integer as "age_at_collection",
NULL::text as "method",
NULL::text as "site",
NULL::text as "spatial_qualifier",
NULL::text as "laterality",
NULL::text as "has_access_policy",
NULL::text as "id"