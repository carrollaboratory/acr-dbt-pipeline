{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
        NULL::text as "subjectassertion_id",
        NULL::text as "source_data_id"
    )

    select 
        * 
    from source
    