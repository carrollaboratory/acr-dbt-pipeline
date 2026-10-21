{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
       NULL::text as "study_id",
       NULL::text as "funding_source"
    )

    select 
        * 
    from source
    