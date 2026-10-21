{{ config(materialized='table', schema='cmg_yale_data') }} 

select 
  NULL::text as "family_type",
  NULL::text as "family_description",
  
  code::text as "consanguinity",
  coalesce(consanguinity, 'FTD_NULL') AS "ftd_consanguinity", -- flag nulls for analysis
  coalesce(code, 'Needs Handling') AS "ftd_flag_consanguinity", -- flag unhandled strings
  
  NULL::text as "family_study_focus",
  {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cmg_yale') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cmg_yale') }}::text as "id"
from (select 
        distinct consent_id, family_id, code, consanguinity
      from {{ ref('cmg_yale_stg_family') }}
      left join {{ ref('fm_consanguinity') }}
      on lower(consanguinity) = src_format
      ) as s 