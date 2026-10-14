{{ config(materialized='table', schema='GREGoR_R03_HMB_20250612_data') }}

    with source as (
        select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='phs003047') }}::text as "accesspolicy_id",
        LOWER(participant.consent_code)::text as "access_policy_code"
        from {{ ref('GREGoR_R03_HMB_20250612_stg_participant') }} as participant
    )

    select 
        * 
    from source
    