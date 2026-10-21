{{ config(materialized='table', schema='gregor_synthetic_data') }}
    with source as (
        select distinct
        'participant'::text as "subject_type",
        'human'::text as "organism_type",
       {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='sb',descriptor=['participant.participant_id', 'participant.consent_code'], study_id='gregor_synthetic') }}::text as "id",
       {{ generate_global_id(prefix='dm',descriptor=['participant.participant_id', 'participant.consent_code'], study_id='gregor_synthetic') }}::text as "has_demographics_id"
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
    )

    select 
        * 
    from source
    