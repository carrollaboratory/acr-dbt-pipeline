{{ config(materialized='table', schema='cser_data') }}

WITH split_race AS (
  SELECT
    subject_id,
    src_race
  FROM {{ ref('cser_stg_subject') }},
  UNNEST(SPLIT(race_ethnicity, '|')) AS t(src_race)
),

race_alone AS (
  SELECT
    subject_id,
    CASE
      WHEN src_race IN ('Hispanic or Latino', 'Hispanic/Latino')
        THEN NULL                              
      ELSE src_race
    END AS race_val
  FROM split_race
)

select distinct
  {{ generate_global_id(prefix='dm',descriptor=['subject_id', 'consent_id'], study_id='cser') }}::text as "demographics_id",
  COALESCE(dr.code, 'unknown')::text as "race"
from {{ ref('cser_stg_subject') }} as s
left join race_alone as ra
    using(subject_id) 
left join {{ ref('dm_race') }} as dr
    on lower(ra.race_val) = lower(dr.src_format)