{{ config(materialized='table', schema='GREGoR_R03_HMB_20250612_data') }}

    with source as (
        select DISTINCT
        NULL as "date_of_birth",
        NULL as "date_of_birth_type",
        CASE 
            WHEN participant.sex = 'Female' THEN 'female'
            WHEN participant.sex = 'Male' THEN 'male'
            WHEN participant.sex = 'Unknown' THEN 'unknown'
            WHEN participant.sex = 'Intersex' THEN 'intersex'
            WHEN participant.sex IS NULL THEN 'unknown'
            ELSE CONCAT('FTD_FLAG: unhandled sex: ',sex)
        END::text as "sex",
        participant.sex::text as "sex_display",
        CASE
            WHEN participant.reported_race IS NULL THEN 'unknown'
            ELSE participant.reported_race
        END::text as "race_display",
        CASE
            WHEN  participant.reported_ethnicity = 'Hispanic or Latino' THEN 'hispanic_or_latino'
            WHEN  participant.reported_ethnicity = 'Not Hispanic or Latino' THEN 'not_hispanic_or_latino'
            WHEN  participant.reported_ethnicity IS NULL THEN 'unknown'
        END::text as "ethnicity",
        CASE
            WHEN participant.reported_ethnicity IS NULL THEN 'unknown'
            ELSE participant.reported_ethnicity
        END::text as "ethnicity_display",
        participant.age_at_last_observation::integer as "age_at_last_vital_status",
        NULL as "vital_status",
       {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='phs003047') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='dm',descriptor=['participant.participant_id'], study_id='phs003047') }}::text as "id"
        from {{ ref('GREGoR_R03_HMB_20250612_stg_participant') }} as participant
    )

    select 
        * 
    from source
    