{{ config(materialized='table', schema='cser_data') }}

select distinct
NULL::text as "family_type",
NULL::text as "family_description",
NULL::text as "consanguinity",
NULL::text as "family_study_focus",
    {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cser') }}::text as "id"
from {{ ref('cser_stg_subject') }} as subject
