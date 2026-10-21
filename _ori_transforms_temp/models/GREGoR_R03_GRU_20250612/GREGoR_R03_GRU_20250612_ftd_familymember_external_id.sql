{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select distinct
        {{ generate_global_id(prefix='fm',descriptor=['participant.participant_id'], study_id='GREGoR_R03_GRU_20250612') }}::text as "familyMember_id",
        participant.participant_id::text as "external_id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
    )

    select 
        * 
    from source
    
