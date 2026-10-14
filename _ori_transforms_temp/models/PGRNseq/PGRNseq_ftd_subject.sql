{{ config(materialized='table', schema='PGRNseq_data') }}

select distinct
'participant'::text as "subject_type",
NULL::text as "organism_type",
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs000906') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sb',descriptor=['subjectconsent.subject_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as "id",
    {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as "has_demographics_id"
from {{ ref('PGRNseq_stg_subjectconsent') }} as subjectconsent
left join {{ ref('PGRNseq_stg_demographics') }} as demographics
using (subject_id)

