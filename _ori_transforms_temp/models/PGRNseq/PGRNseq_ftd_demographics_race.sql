{{ config(materialized='table', schema='PGRNseq_data') }}

select 
  {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id', 'sc.consent'], study_id='phs000906') }}::text as "demographics_id",
 CASE 
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41259' THEN 'american_indian_or_alaskan_native'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41260' THEN 'asian'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C16352' THEN 'black_or_african_american'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41219' THEN 'native_hawaiian_or_pacific_islander'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41261' THEN 'white'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C17998' THEN 'unknown'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C43234' THEN 'unknown'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = '.' THEN 'unknown'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'NA' THEN 'unknown'
     WHEN UNNEST(SPLIT(demographics.race, ',')) = 'OTHER' THEN 'other_race'
 END::text as "race"
from {{ ref('PGRNseq_stg_demographics') }} as demographics
left join {{ ref('PGRNseq_stg_subjectconsent') }} as sc
using(subject_id)