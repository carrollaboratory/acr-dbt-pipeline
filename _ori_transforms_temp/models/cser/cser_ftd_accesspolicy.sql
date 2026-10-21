{{ config(materialized='table', schema='cser_data') }}

select distinct
NULL::text as "disease_limitation",
ap.consent_description::text as "description",
NULL::text as "website",
{{ generate_global_id(prefix='ap',descriptor=['s.ingest_provenance'], study_id='cser') }}::text as "id"
from {{ ref('cser_stg_subject') }} as s
left join {{ ref('ap_access_policy') }} as ap
on lower(s.consent_id) = lower(ap.consent_code)