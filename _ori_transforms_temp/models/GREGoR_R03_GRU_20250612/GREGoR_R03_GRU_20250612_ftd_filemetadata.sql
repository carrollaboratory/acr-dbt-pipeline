{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select 
        GEN_UNKNOWN.code::text as "code",
       GEN_UNKNOWN.display::text as "display",
       GEN_UNKNOWN.value_code::text as "value_code",
       GEN_UNKNOWN.value_display::text as "value_display",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_GRU_20250612') }}::text as "id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
        join {{ ref('GREGoR_R03_GRU_20250612_stg_phenotype') }} as phenotype
on participant.participant_id = phenotype.participant_id 
    )

    select 
        * 
    from source
    