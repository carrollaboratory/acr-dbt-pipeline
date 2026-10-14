{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select distinct
       {{ generate_global_id(prefix='sb',descriptor=['participant.participant_id', 'participant.consent_code'], study_id='gregor_synthetic') }}::text as "Subject_id",
       participant.participant_id::text as "external_id"
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
    )

    select 
        * 
    from source
    