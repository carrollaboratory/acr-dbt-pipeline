{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
       NULL::text as "study_id",
       NULL::text as "external_study_id"
    )

    select 
        * 
    from source
    