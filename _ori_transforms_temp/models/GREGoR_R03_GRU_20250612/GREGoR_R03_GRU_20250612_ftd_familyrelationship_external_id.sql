{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='fm',descriptor=['participant.participant_id, participant.family_id'], study_id='phs003047') }}::text as "familyMember_id",
        participant.participant_id::text as "external_id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
        join {{ ref('GREGoR_R03_GRU_20250612_stg_phenotype') }} as phenotype
        on participant.participant_id = phenotype.participant_id 
    )

    select 
        * 
    from source
    
