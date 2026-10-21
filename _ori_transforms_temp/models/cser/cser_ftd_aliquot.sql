{{ config(materialized='table', schema='cser_data') }}

select 
NULL::text as "availablity_status",
NULL::text as "quantity_number",
NULL::text as "quantity_units",
NULL::text as "concentration_number",
NULL::text as "concentration_unit",
NULL::text as "has_access_policy",
NULL::text as "id",
NULL::text as "sample_id"