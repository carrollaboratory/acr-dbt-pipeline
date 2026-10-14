{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  NULL::integer as "date_of_birth",
  NULL::text as "date_of_birth_type",
  
  coalesce(sex_code,'unknown') AS "sex",
  coalesce(sex,'FTD_NULL') AS "ftd_sex", -- flag nulls for analysis
  coalesce(sex_code,'Needs Handling') AS "ftd_flag_sex", -- flag unhandled strings
  
  coalesce(sex_display,'Unknown') AS "sex_display",
  coalesce(sex,'FTD_NULL') AS "ftd_sex_display", -- flag nulls for analysis
  coalesce(sex_display,'Needs Handling') AS "ftd_flag_sex_display", -- flag unhandled strings
  
  coalesce(race_display,'Unknown') AS "race_display",
  coalesce(ancestry, 'FTD_NULL') AS "ftd_race", -- flag nulls for analysis
  coalesce(race_display, 'Needs Handling') AS "ftd_flag_race", -- flag unhandled strings

  'SNOMED:261665006'::text as "ethnicity",
  'Unknown'::text as "ethnicity_display",
  NULL::integer as "age_at_last_vital_status",
  'Unspecified'::text as "vital_status",
   {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cmg_yale') }}::text as "has_access_policy",
   {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "id"
from (select 
        distinct 
        sex,
        ancestry,
        subject_id,
        consent_id,
        sex.code as "sex_code",
        sex.display as "sex_display",
        race.display as "race_display"
     from {{ ref('cmg_yale_stg_subject') }}
     left join {{ ref('dm_sex') }} as sex
     on lower(sex) = sex.src_format
     left join {{ ref('dm_race') }} as race
     on lower(ancestry) = race.src_format  
     ) as s
