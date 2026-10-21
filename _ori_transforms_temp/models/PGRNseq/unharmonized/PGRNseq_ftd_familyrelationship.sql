{{ config(materialized='table', schema='PGRNseq_data') }}

select 
NULL::text as "family_member",
NULL::text as "other_family_member",
NULL::text as "relationship_code",
NULL::text as "has_access_policy",
NULL::text as "id"
