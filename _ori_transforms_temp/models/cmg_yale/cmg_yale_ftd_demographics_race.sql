{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  coalesce(race_code,'unknown') AS "race",
  coalesce(ancestry, 'FTD_NULL') as "ftd_race", -- flag nulls for analysis
  coalesce(race_code, 'Needs Handling') as "ftd_flag_race", -- flag unhandled strings
  {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "demographics_id"
from (select 
        distinct 
        ancestry,
        subject_id,
        race.code as "race_code",
        race.display as "race_display"
     from {{ ref('cmg_yale_stg_subject') }}
     left join {{ ref('dm_race') }} as race
     on lower(ancestry) = src_format      
     ) as s