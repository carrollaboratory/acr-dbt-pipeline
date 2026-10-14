{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select 
        GEN_UNKNOWN.snapshot_id::text as "snapshot_id",
       GEN_UNKNOWN.google_data_project::text as "google_data_project",
       GEN_UNKNOWN.snapshot_dataset::text as "snapshot_dataset",
       GEN_UNKNOWN.table::text as "table",
       GEN_UNKNOWN.parameterized_query::text as "parameterized_query",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_GRU_20250612') }}::text as "id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
        join {{ ref('GREGoR_R03_GRU_20250612_stg_phenotype') }} as phenotype
on participant.participant_id = phenotype.participant_id  join {{ ref('GREGoR_R03_GRU_20250612_stg_experiment') }} as experiment
on   join {{ ref('GREGoR_R03_GRU_20250612_stg_anvil_project') }} as anvil_project
on  
    )

    select 
        * 
    from source
    