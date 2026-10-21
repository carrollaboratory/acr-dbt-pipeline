{{ config(materialized='table', schema='cmg_bh_data') }}

select 
  {{ generate_global_id(prefix='dm',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "demographics_id",
    case 
    when ancestry in ('american_indian_or_alaskan_native',
                        'asian',
                        'black_or_african_american',
                        'native_hawaiian_or_pacific_islander',
                        'white',
                        'other_race',
                        'unknown',
                        'asked_but_unknown')
      then ancestry
    when ancestry = 'American Indian or Alaskan Native'
      then 'american_indian_or_alaskan_native'
    when ancestry = 'Asian'
      then 'asian'
    when ancestry = 'Black or African American'
      then 'black_or_african_american'
    when ancestry = 'Native Hawaiian or Pacific Islander'
      then 'native_hawaiian_or_pacific_islander'
    when ancestry = 'White'
      then 'white'
    when ancestry = 'Other'
      then 'other_race'
    when ancestry = 'Unknown'
      then 'unknown'
    when ancestry = 'Asked but Unknown'
      then 'asked_but_unknown'
    when ancestry is null
      then null
    else CONCAT('FTD_FLAG:unhandled race: ',ancestry)
   end as "race",
from (select distinct ancestry, subject_id from {{ ref('cmg_bh_stg_subject') }}) as s