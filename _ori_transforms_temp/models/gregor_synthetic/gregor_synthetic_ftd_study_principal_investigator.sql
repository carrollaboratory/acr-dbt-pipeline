{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
       NULL::text as "study_id",
       NULL::text as "principal_investigator"
    )

    select 
        * 
    from source
    