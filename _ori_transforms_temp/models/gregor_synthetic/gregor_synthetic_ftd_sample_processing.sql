{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
        NULL::text as "sample_id",
        NULL::text as "processing"
    )

    select 
        * 
    from source
    