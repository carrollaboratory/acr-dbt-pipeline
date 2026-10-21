{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  distinct
  coalesce(curie, 'FAMMEMB')::text as "family_role",
  coalesce(proband_relationship, 'FTD_NULL') AS "ftd_family_role", -- flag nulls for analysis
  coalesce(curie, 'Needs Handling') AS "ftd_flag_family_role", -- flag unhandled strings
  {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "family_member",
  {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cmg_yale') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='fm',descriptor=['family_id','subject_id'], study_id='cmg_yale') }}::text as "id",
  {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cmg_yale') }}::text as "family_id"
from (select distinct subject_id, consent_id, family_id, curie, relationship_to_proband, proband_relationship
      from {{ ref('cmg_yale_stg_subject') }}
      left join {{ ref('fm_family_role') }}
      on relationship_to_proband = lower(proband_relationship)
      ) as s