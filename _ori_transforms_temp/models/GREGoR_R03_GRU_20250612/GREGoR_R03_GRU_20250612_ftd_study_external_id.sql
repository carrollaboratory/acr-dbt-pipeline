{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='st',descriptor=['anvil_project.registered_identifier'], study_id='phs003047') }}::text as "study_id",
       anvil_project.registered_identifier::text as "external_id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_anvil_project') }} as anvil_project
    )

    select 
        * 
    from source
    