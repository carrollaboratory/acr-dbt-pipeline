{{ config(materialized='table', schema='PGRNseq_data') }}

select 
  {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id', 'sc.consent'], study_id='phs000906') }}::text as "demographics_id",
  demographics.subject_id::text as "external_id"
from {{ ref('PGRNseq_stg_demographics') }} as demographics
left join {{ ref('PGRNseq_stg_subjectconsent') }} as sc
using(subject_id)
