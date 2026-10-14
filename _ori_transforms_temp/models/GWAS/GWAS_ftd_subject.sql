{{ config(materialized='table', schema='GWAS_data') }}

select 
  CASE 
      WHEN subjectconsent.consent != 0 THEN 'participant'
      ELSE 'non_participant'
  END::text as subject_type,  
  NULL as "organism_type",
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001584') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sb',descriptor=['subjectconsent.subject_id'], study_id='phs001584') }}::text as "id",
    {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id'], study_id='phs001584') }}::text as "has_demographics_id"
from {{ ref('GWAS_stg_subjectconsent') }} as subjectconsent
join {{ ref('GWAS_stg_demographics') }} as demographics
using (subject_id)

