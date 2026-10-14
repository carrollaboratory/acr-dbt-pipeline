{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select 
        GEN_UNKNOWN.family_type::text as "family_type",
       GEN_UNKNOWN.family_description::text as "family_description",
       GEN_UNKNOWN.consanguinity::text as "consanguinity",
       GEN_UNKNOWN.family_study_focus::text as "family_study_focus",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_GRU_20250612') }}::text as "has_access_policy",
        -- participant.family_id::text as "id"
       -- Check if using the auto-generated id is correct. 
       {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_GRU_20250612') }}::text as "id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
        join {{ ref('GREGoR_R03_GRU_20250612_stg_phenotype') }} as phenotype
        on participant.participant_id = phenotype.participant_id 
    )

    select 
        * 
    from source
    