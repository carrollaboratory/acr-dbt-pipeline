{{ config(materialized='table', schema='GREGoR_R03_HMB_20250612_data') }}

    with source as (
        select DISTINCT
        NULL as "parent_study_id",
       anvil_project.title::text as "study_title",
       {{ generate_global_id(prefix='st',descriptor=['anvil_project.registered_identifier'], study_id='phs003047') }}::text as "id"
        from {{ ref('GREGoR_R03_HMB_20250612_stg_anvil_project') }} as anvil_project
    )

    select 
        * 
    from source
    