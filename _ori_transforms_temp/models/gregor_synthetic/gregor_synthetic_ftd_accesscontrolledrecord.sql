{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
       NULL::text as "has_access_policy",
       NULL::text as "id"
    )

    select 
        * 
    from source
    