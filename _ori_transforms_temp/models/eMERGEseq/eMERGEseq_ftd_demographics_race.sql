{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id'], study_id='phs001616') }}::text as "demographics_id",
       CASE demographics.race
            WHEN 'C41259' THEN 'american_indian_or_alaskan_native'
            WHEN 'C41260' THEN 'asian'
            WHEN 'C16352' THEN 'black_or_african_american'
            WHEN 'C41219' THEN 'native_hawaiian_or_pacific_islander'
            WHEN 'C41261' THEN 'white'
            WHEN 'C17998' THEN 'unknown'
            WHEN 'C43234' THEN 'unknown'
            WHEN 'C13652' THEN 'unknown'
            WHEN '.' THEN 'unknown'
            WHEN 'NA' THEN 'unknown'
            WHEN 'OTHER' THEN 'other_race'
       END::text as "race"
        from {{ ref('eMERGEseq_stg_demographics') }} as demographics
    )

    select 
        * 
    from source
