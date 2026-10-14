{{ config(materialized='table', schema='GREGoR_R03_HMB_20250612_data') }}

    with source as (
        select 
        GEN_UNKNOWN.age_at_collection::integer as "age_at_collection",
       GEN_UNKNOWN.method::text as "method",
       GEN_UNKNOWN.site::text as "site",
       GEN_UNKNOWN.spatial_qualifier::text as "spatial_qualifier",
       GEN_UNKNOWN.laterality::text as "laterality",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_HMB_20250612') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='GREGoR_R03_HMB_20250612') }}::text as "id"
        from {{ ref('GREGoR_R03_HMB_20250612_stg_participant') }} as participant
        join {{ ref('GREGoR_R03_HMB_20250612_stg_phenotype') }} as phenotype
on participant.participant_id = phenotype.participant_id 
    )

    select 
        * 
    from source
    