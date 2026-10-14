{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select distinct
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text as "accesspolicy_id",
        lower(participant.consent_code)::text as "access_policy_code"
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
    )

    select 
        * 
    from source
    