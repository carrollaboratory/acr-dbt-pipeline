{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_GRU_20250612') }}::text as "datasource_id",
       GEN_UNKNOWN.external_id::text as "external_id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
        join {{ ref('GREGoR_R03_GRU_20250612_stg_phenotype') }} as phenotype
on participant.participant_id = phenotype.participant_id  join {{ ref('GREGoR_R03_GRU_20250612_stg_experiment') }} as experiment
on   join {{ ref('GREGoR_R03_GRU_20250612_stg_anvil_project') }} as anvil_project
on  
    )

    select 
        * 
    from source
    