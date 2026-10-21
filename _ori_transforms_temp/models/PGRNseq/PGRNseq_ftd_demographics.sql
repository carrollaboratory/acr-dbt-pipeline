{{ config(materialized='table', schema='PGRNseq_data') }}

select 
CASE
    WHEN demographics.year_birth = 'NA' THEN null
    WHEN demographics.year_birth = '.' THEN null
    ELSE demographics.year_birth
END::integer as "date_of_birth",
'year_only'::text as "date_of_birth_type",
CASE demographics.sex
    WHEN 'C46110' THEN 'female'
    WHEN 'C46109' THEN 'male'
    WHEN 'U' THEN 'unknown'
    WHEN '.' THEN 'unknown'
    WHEN 'NA' THEN 'unknown'
END::text as "sex",       
CASE demographics.sex
    WHEN 'C46110' THEN 'Female'
    WHEN 'C46109' THEN 'Male'
    WHEN 'U' THEN 'Unknown'
    WHEN '.' THEN 'Unknown'
    WHEN 'NA' THEN 'Unknown'
END::text as "sex_display",
CASE
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41259' THEN 'American Indian or Alaska Native'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41260' THEN 'Asian'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C16352' THEN 'Black or African American'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41219' THEN 'Native Hawaiian or Other Pacific Islander'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C41261' THEN 'White'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C17998' THEN 'unknown'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'C43234' THEN 'unknown'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = '.' THEN 'unknown'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'NA' THEN 'unknown'
    WHEN UNNEST(SPLIT(demographics.race, ',')) = 'OTHER' THEN 'other race'
END::text as "race_display",
CASE demographics.ethnicity
    WHEN 'C17459' THEN 'hispanic_or_latino'
    WHEN 'C41222' THEN 'not_hispanic_or_latino'
    WHEN 'C41221' THEN 'unknown'
    WHEN '.' THEN 'unknown'
    WHEN 'NA' THEN 'unknown'
END::text as "ethnicity",
CASE demographics.ethnicity
    WHEN 'C17459' THEN 'Hispanic or Latino'
    WHEN 'C41222' THEN 'Not Hispanic or Latino'
    WHEN 'C41221' THEN 'unknown'
    WHEN '.' THEN 'unknown'
    WHEN 'NA' THEN 'unknown'
END::text as "ethnicity_display",
NULL as "age_at_last_vital_status",
NULL as "vital_status",
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs000906') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as "id"
from {{ ref('PGRNseq_stg_demographics') }} as demographics
join {{ ref('PGRNseq_stg_subjectconsent') }} as subjectconsent
using(subject_id)

