{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  'participant'::text as "subject_type",
  'human'::text as "organism_type",
    {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cmg_yale') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "id",
    {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "has_demographics_id"
from (select distinct subject_id, consent_id from {{ ref('cmg_yale_stg_subject') }} ) AS s