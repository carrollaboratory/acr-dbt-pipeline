{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "family_member",
NULL::text as "family_role",
NULL::text as "has_access_policy",
NULL::text as "id",
NULL::text as "family_id"
